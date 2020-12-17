/*
     File: APAHeroCharacter.m
 Abstract: n/a
  Version: 1.2
 */

#import "APAHeroCharacter.h"
#import "APAGraphicsUtilities.h"
#import "APAMultiplayerLayeredCharacterScene.h"


#define kHeroProjectileSpeed 480.0
#define kHeroProjectileLifetime 1.0 // 1.0 seconds until the projectile disappears
#define kHeroProjectileFadeOutTime 0.6 // 0.6 seconds until the projectile starts to fade out

@implementation APAHeroCharacter

#pragma mark - Initialization
- (id)initAtPosition:(CGPoint)position withPlayer:(APAPlayer *)player {
    return [self initWithTexture:nil atPosition:position withPlayer:player];
}

- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position withPlayer:(APAPlayer *)player {
    self = [super initWithTexture:texture atPosition:position];
    if (self) {
        _player = player;
        
        // Rotate by PI radians (180 degrees) so hero faces down rather than toward wall at start of game.
        self.zRotation = M_PI;
        self.zPosition = -0.25;
        self.name = [NSString stringWithFormat:@"Hero"];
    }
    
    return self;
}

#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kCharacterCollisionRadius];
    
    // Our object type for collisions.
    self.physicsBody.categoryBitMask = APAColliderTypeHero;
    
    // Collides with these objects.
    self.physicsBody.collisionBitMask = APAColliderTypeGoblinOrBoss | APAColliderTypeHero | APAColliderTypeWall | APAColliderTypeCave;
    
    // We want notifications for colliding with these objects.
    self.physicsBody.contactTestBitMask = APAColliderTypeGoblinOrBoss;
}

- (void)collidedWith:(SKPhysicsBody *)other {
    if (other.categoryBitMask & APAColliderTypeGoblinOrBoss) {
        APACharacter *enemy = (APACharacter *)other.node;
        if (!enemy.dying) {
            [self applyDamage:5.0f];
            self.requestedAnimation = APAAnimationStateGetHit;
        }
    }
}

- (void)animationDidComplete:(APAAnimationState)animationState {
    switch (animationState) {
        case APAAnimationStateDeath:{
            APAMultiplayerLayeredCharacterScene *scene = [self characterScene];
            
            SKEmitterNode *emitter = [[self deathEmitter] copy];
            emitter.zPosition = -0.8;
            [self addChild:emitter];
            APARunOneShotEmitter(emitter, 4.5f);
            
            [self runAction:[SKAction sequence:@[
                                                 [SKAction waitForDuration:4.0f],
                                                 [SKAction runBlock:^{
                                                     [scene heroWasKilled:self];
                                                 }],
                                                 [SKAction removeFromParent],
                                                 ]]];
            break;}
            
        case APAAnimationStateAttack:
            [self fireProjectile];
            break;
            
        default:
            break;
    }
}

#pragma mark - Projectiles
- (void)fireProjectile {
    APAMultiplayerLayeredCharacterScene *scene = [self characterScene];
    
    SKSpriteNode *projectile = [[self projectile] copy];
    projectile.position = self.position;
    projectile.zRotation = self.zRotation;
    
    SKEmitterNode *emitter = [[self projectileEmitter] copy];
    emitter.targetNode = [self.scene childNodeWithName:@"world"];
    [projectile addChild:emitter];
    
    [scene addNode:projectile atWorldLayer:APAWorldLayerCharacter];
    
    CGFloat rot = self.zRotation;
    
    [projectile runAction:[SKAction moveByX:-sinf(rot)*kHeroProjectileSpeed*kHeroProjectileLifetime
                                          y:cosf(rot)*kHeroProjectileSpeed*kHeroProjectileLifetime
                                   duration:kHeroProjectileLifetime]];
    
    [projectile runAction:[SKAction sequence:@[[SKAction waitForDuration:kHeroProjectileFadeOutTime],
                                               [SKAction fadeOutWithDuration:kHeroProjectileLifetime - kHeroProjectileFadeOutTime],
                                               [SKAction removeFromParent]]]];
    [projectile runAction:[self projectileSoundAction]];
    
    projectile.userData = [NSMutableDictionary dictionaryWithObject:self.player forKey:kPlayer];
}

- (SKSpriteNode *)projectile {
    // Overridden by subclasses to return a suitable projectile.
    return nil;
}

- (SKEmitterNode *)projectileEmitter {
    // Overridden by subclasses to return the particle emitter to attach to the projectile.
    return nil;
}

#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    [super loadSharedAssets];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedProjectileSoundAction = [SKAction playSoundFileNamed:@"magicmissile.caf" waitForCompletion:NO];
        sSharedDeathEmitter = [SKEmitterNode apa_emitterNodeWithEmitterNamed:@"Death"];
        sSharedDamageEmitter = [SKEmitterNode apa_emitterNodeWithEmitterNamed:@"Damage"];
    });
}

static SKAction *sSharedProjectileSoundAction = nil;
- (SKAction *)projectileSoundAction {
    return sSharedProjectileSoundAction;
}

static SKEmitterNode *sSharedDeathEmitter = nil;
- (SKEmitterNode *)deathEmitter {
    return sSharedDeathEmitter;
}

static SKEmitterNode *sSharedDamageEmitter = nil;
- (SKEmitterNode *)damageEmitter {
    return sSharedDamageEmitter;
}

- (SKAction *)damageAction {
    return nil;
}

@end

NSString * const kPlayer = @"kPlayer";
