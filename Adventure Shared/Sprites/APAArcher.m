/*
     File: APAArcher.m
 Abstract: n/a
  Version: 1.2
 */

#import "APAArcher.h"
#import "APAGraphicsUtilities.h"
#import "APAMultiplayerLayeredCharacterScene.h"

#define kArcherAttackFrames 10
#define kArcherGetHitFrames 18
#define kArcherDeathFrames 42
#define kArcherProjectileSpeed 8.0

@implementation APAArcher

#pragma mark - Initialization
- (id)initAtPosition:(CGPoint)position withPlayer:(APAPlayer *)player {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Archer_Idle"];
    SKTexture *texture = [atlas textureNamed:@"archer_idle_0001.png"];
    
    return [super initWithTexture:texture atPosition:position withPlayer:player];
}

#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    [super loadSharedAssets];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedProjectile = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(2.0, 24.0)];
        sSharedProjectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kProjectileCollisionRadius];
        sSharedProjectile.name = @"Projectile";
        sSharedProjectile.physicsBody.categoryBitMask = APAColliderTypeProjectile;
        sSharedProjectile.physicsBody.collisionBitMask = APAColliderTypeWall;
        sSharedProjectile.physicsBody.contactTestBitMask = sSharedProjectile.physicsBody.collisionBitMask;
        
        sSharedProjectileEmitter = [SKEmitterNode apa_emitterNodeWithEmitterNamed:@"ArcherProjectile"];
        sSharedIdleAnimationFrames = APALoadFramesFromAtlas(@"Archer_Idle", @"archer_idle_", kDefaultNumberOfIdleFrames);
        sSharedWalkAnimationFrames = APALoadFramesFromAtlas(@"Archer_Walk", @"archer_walk_", kDefaultNumberOfWalkFrames);
        sharedAttackAnimationFrames = APALoadFramesFromAtlas(@"Archer_Attack", @"archer_attack_", kArcherAttackFrames);
        sharedGetHitAnimationFrames = APALoadFramesFromAtlas(@"Archer_GetHit", @"archer_getHit_", kArcherGetHitFrames);
        sharedDeathAnimationFrames = APALoadFramesFromAtlas(@"Archer_Death", @"archer_death_", kArcherDeathFrames);
        sSharedDamageAction = [SKAction sequence:@[[SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:10.0 duration:0.0],
                                                   [SKAction waitForDuration:0.75],
                                                   [SKAction colorizeWithColorBlendFactor:0.0 duration:0.25]
                                                   ]];
    });
}

static SKSpriteNode *sSharedProjectile = nil;
- (SKSpriteNode *)projectile {
    return sSharedProjectile;
}

static SKEmitterNode *sSharedProjectileEmitter = nil;
- (SKEmitterNode *)projectileEmitter {
    return sSharedProjectileEmitter;
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

static SKAction *sSharedDamageAction = nil;
- (SKAction *)damageAction {
    return sSharedDamageAction;
}

@end
