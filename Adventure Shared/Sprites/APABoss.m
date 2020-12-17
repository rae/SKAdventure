/*
     File: APABoss.m
 Abstract: n/a
  Version: 1.2
 */

#import "APABoss.h"
#import "APAChaseAI.h"
#import "APAGraphicsUtilities.h"
#import "APAHeroCharacter.h"
#import "APAMultiplayerLayeredCharacterScene.h"

#define kBossWalkFrames 35
#define kBossIdleFrames 32
#define kBossAttackFrames 42
#define kBossDeathFrames 45
#define kBossGetHitFrames 22

#define kBossCollisionRadius 40
#define kBossChaseRadius (kBossCollisionRadius * 4)

@implementation APABoss

#pragma mark - Initialization
- (id)initAtPosition:(CGPoint)position {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Boss_Idle"];
    
    self = [super initWithTexture:[atlas textureNamed:@"boss_idle_0001.png"] atPosition:position];
    if (self) {
        self.movementSpeed = kMovementSpeed * 0.35f;
        self.animationSpeed = 1.0f/35.0f;
        
        self.zPosition = -0.25f;
        self.name = @"Boss";
        
        self.attacking = NO;
        
        // Make it AWARE!
        APAChaseAI *intelligence = [[APAChaseAI alloc] initWithCharacter:self target:nil];
        intelligence.chaseRadius = kBossChaseRadius;
        intelligence.maxAlertRadius = kBossChaseRadius * 4.0f;
        self.intelligence = intelligence;
    }
    
    return self;
}

#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kBossCollisionRadius];
    
    // Our object type for collisions.
    self.physicsBody.categoryBitMask = APAColliderTypeGoblinOrBoss;
    
    // Collides with these objects.
    self.physicsBody.collisionBitMask = APAColliderTypeGoblinOrBoss | APAColliderTypeHero | APAColliderTypeProjectile | APAColliderTypeWall;
    
    // We want notifications for colliding with these objects.
    self.physicsBody.contactTestBitMask = APAColliderTypeProjectile;
}

- (void)animationDidComplete:(APAAnimationState)animationState {
    [super animationDidComplete:animationState];
    if (animationState == APAAnimationStateDeath) {
        // In a real game, you'd complete the level here, maybe as shown by commented code below.
        [self removeAllActions];
        [self runAction:[SKAction sequence:@[
                                             [SKAction waitForDuration:3.00],
                                             [SKAction fadeOutWithDuration:2.0f],
                                             [SKAction removeFromParent],
                                             /*[SKAction runBlock:^{
                                                 [[self characterScene] gameOver];
                                             }]*/
                                            ]]];
    }
}

- (void)collidedWith:(SKPhysicsBody *)other {
    if (self.dying) {
        return;
    }
    
    if (other.categoryBitMask & APAColliderTypeProjectile) {
        self.requestedAnimation = APAAnimationStateGetHit;
        CGFloat damage = 2.0f;
        BOOL killed = [self applyDamage:damage fromProjectile:other.node];
        if (killed) {
            [[self characterScene] addToScore:100 afterEnemyKillWithProjectile:other.node];
        }
    }
}

- (void)performDeath {
    [self removeAllActions];
    
    [super performDeath];
}

#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    [super loadSharedAssets];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedIdleAnimationFrames = APALoadFramesFromAtlas(@"Boss_Idle", @"boss_idle_", kBossIdleFrames);
        sSharedWalkAnimationFrames = APALoadFramesFromAtlas(@"Boss_Walk", @"boss_walk_", kBossWalkFrames);
        sharedAttackAnimationFrames = APALoadFramesFromAtlas(@"Boss_Attack", @"boss_attack_", kBossAttackFrames);
        sharedGetHitAnimationFrames = APALoadFramesFromAtlas(@"Boss_GetHit", @"boss_getHit_", kBossGetHitFrames);
        sharedDeathAnimationFrames = APALoadFramesFromAtlas(@"Boss_Death", @"boss_death_", kBossDeathFrames);
        sSharedDamageEmitter = [SKEmitterNode apa_emitterNodeWithEmitterNamed:@"BossDamage"];
        sSharedDamageAction = [SKAction sequence:@[[SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.0],
                                                   [SKAction waitForDuration:0.5],
                                                   [SKAction colorizeWithColorBlendFactor:0.0 duration:0.1]
                                                   ]];
    });
}

static SKEmitterNode *sSharedDamageEmitter = nil;
- (SKEmitterNode *)damageEmitter {
    return sSharedDamageEmitter;
}

static SKAction *sSharedDamageAction = nil;
- (SKAction *)damageAction {
    return sSharedDamageAction;
}

static NSArray *sSharedIdleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return sSharedIdleAnimationFrames;
}

static NSArray *sSharedWalkAnimationFrames = nil;
- (NSArray *)walkAnimationFrames {
    return sSharedWalkAnimationFrames;
}

static NSArray *sharedAttackAnimationFrames = nil;
- (NSArray *)attackAnimationFrames {
    return sharedAttackAnimationFrames;
}

static NSArray *sharedGetHitAnimationFrames = nil;
- (NSArray *)getHitAnimationFrames {
    return sharedGetHitAnimationFrames;
}

static NSArray *sharedDeathAnimationFrames = nil;
- (NSArray *)deathAnimationFrames {
    return sharedDeathAnimationFrames;
}

@end
