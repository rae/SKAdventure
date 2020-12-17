/*
     File: APAWarrior.m
 Abstract: n/a
  Version: 1.2
 */

#import "APAWarrior.h"
#import "APAGraphicsUtilities.h"
#import "APAMultiplayerLayeredCharacterScene.h"

#define kWarriorIdleFrames 29
#define kWarriorThrowFrames 10
#define kWarriorGetHitFrames 20
#define kWarriorDeathFrames 90

@implementation APAWarrior

#pragma mark - Initialization
- (id)initAtPosition:(CGPoint)position withPlayer:(APAPlayer *)player {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Warrior_Idle"];
    SKTexture *texture = [atlas textureNamed:@"warrior_idle_0001.png"];
    
    return [super initWithTexture:texture atPosition:position withPlayer:player];
}

#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    [super loadSharedAssets];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Environment"];

        sSharedProjectile = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"warrior_throw_hammer.png"]];
        sSharedProjectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kProjectileCollisionRadius];
        sSharedProjectile.name = @"Projectile";
        sSharedProjectile.physicsBody.categoryBitMask = APAColliderTypeProjectile;
        sSharedProjectile.physicsBody.collisionBitMask = APAColliderTypeWall;
        sSharedProjectile.physicsBody.contactTestBitMask = sSharedProjectile.physicsBody.collisionBitMask;
        
        sSharedProjectileEmitter = [SKEmitterNode apa_emitterNodeWithEmitterNamed:@"WarriorProjectile"];
        sSharedIdleAnimationFrames = APALoadFramesFromAtlas(@"Warrior_Idle", @"warrior_idle_", kWarriorIdleFrames);
        sSharedWalkAnimationFrames = APALoadFramesFromAtlas(@"Warrior_Walk", @"warrior_walk_", kDefaultNumberOfWalkFrames);
        sharedAttackAnimationFrames = APALoadFramesFromAtlas(@"Warrior_Attack", @"warrior_attack_", kWarriorThrowFrames);
        sharedGetHitAnimationFrames = APALoadFramesFromAtlas(@"Warrior_GetHit", @"warrior_getHit_", kWarriorGetHitFrames);
        sharedDeathAnimationFrames = APALoadFramesFromAtlas(@"Warrior_Death", @"warrior_death_", kWarriorDeathFrames);
        sSharedDamageAction = [SKAction sequence:@[[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:10.0 duration:0.0],
                                                   [SKAction waitForDuration:0.5],
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
