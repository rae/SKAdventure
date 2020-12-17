/*
     File: APAHeroCharacter.h
 Abstract: n/a
  Version: 1.2
 */

#import "APAEnemyCharacter.h"

@class APAPlayer;

@interface APAHeroCharacter : APACharacter

@property (nonatomic, weak) APAPlayer *player;

/* Designated Initializer. */
- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position withPlayer:(APAPlayer *)player;

- (id)initAtPosition:(CGPoint)position withPlayer:(APAPlayer *)player;

- (void)fireProjectile;
- (SKSpriteNode *)projectile;
- (SKEmitterNode *)projectileEmitter;

@end


extern NSString * const kPlayer;
