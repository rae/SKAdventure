/*
     File: APACharacter.h
 Abstract: n/a
  Version: 1.2
 */

/* Used by the move: method to move a character in a given direction. */
typedef enum : uint8_t {
    APAMoveDirectionForward = 0,
    APAMoveDirectionLeft,
    APAMoveDirectionRight,
    APAMoveDirectionBack,
} APAMoveDirection;

/* The different animation states of an animated character. */
typedef enum : uint8_t {
    APAAnimationStateIdle = 0,
    APAAnimationStateWalk,
    APAAnimationStateAttack,
    APAAnimationStateGetHit,
    APAAnimationStateDeath,
    kAnimationStateCount
} APAAnimationState;

/* Bitmask for the different entities with physics bodies. */
typedef enum : uint8_t {
    APAColliderTypeHero             = 1,
    APAColliderTypeGoblinOrBoss     = 2,
    APAColliderTypeProjectile       = 4,
    APAColliderTypeWall             = 8,
    APAColliderTypeCave             = 16
} APAColliderType;


#define kMovementSpeed 200.0
#define kRotationSpeed 0.06

#define kCharacterCollisionRadius   40
#define kProjectileCollisionRadius  15

#define kDefaultNumberOfWalkFrames 28
#define kDefaultNumberOfIdleFrames 28


@class APAMultiplayerLayeredCharacterScene;
#import "APAParallaxSprite.h"

@interface APACharacter : APAParallaxSprite

@property (nonatomic, getter=isDying) BOOL dying;
@property (nonatomic, getter=isAttacking) BOOL attacking;
@property (nonatomic) CGFloat health;
@property (nonatomic, getter=isAnimated) BOOL animated;
@property (nonatomic) CGFloat animationSpeed;
@property (nonatomic) CGFloat movementSpeed;

@property (nonatomic) NSString *activeAnimationKey;
@property (nonatomic) APAAnimationState requestedAnimation;

/* Preload shared animation frames, emitters, etc. */
+ (void)loadSharedAssets;

/* Initialize a standard sprite. */
- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;

/* Initialize a parallax sprite. */
- (id)initWithSprites:(NSArray *)sprites atPosition:(CGPoint)position usingOffset:(CGFloat)offset;

/* Reset a character for reuse. */
- (void)reset;

/* Overridden Methods. */
- (void)animationDidComplete:(APAAnimationState)animation;
- (void)collidedWith:(SKPhysicsBody *)other;
- (void)performDeath;
- (void)configurePhysicsBody;

/* Assets - should be overridden for animated characters. */
- (NSArray *)idleAnimationFrames;
- (NSArray *)walkAnimationFrames;
- (NSArray *)attackAnimationFrames;
- (NSArray *)getHitAnimationFrames;
- (NSArray *)deathAnimationFrames;
- (SKEmitterNode *)damageEmitter;   // provide an emitter to show damage applied to character
- (SKAction *)damageAction;         // action to run when damage is applied

/* Applying Damage - i.e., decrease health. */
- (BOOL)applyDamage:(CGFloat)damage;
- (BOOL)applyDamage:(CGFloat)damage fromProjectile:(SKNode *)projectile; // use projectile alpha to determine potency

/* Loop Update - called once per frame. */
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;

/* Orientation, Movement, and Attacking. */
- (void)move:(APAMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval;
- (CGFloat)faceTo:(CGPoint)position;
- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval;
- (void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval;
- (void)performAttackAction;

/* Scenes. */
- (void)addToScene:(APAMultiplayerLayeredCharacterScene *)scene; // also adds the shadow blob
- (APAMultiplayerLayeredCharacterScene *)characterScene; // returns the MultiplayerLayeredCharacterScene this character is in

/* Animation. */
- (void)fadeIn:(CGFloat)duration;

@end
