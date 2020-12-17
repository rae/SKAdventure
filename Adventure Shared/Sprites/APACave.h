/*
     File: APACave.h
 Abstract: n/a
  Version: 1.2
 */

#import "APAEnemyCharacter.h"

@class APAGoblin;

@interface APACave : APAEnemyCharacter

@property (nonatomic, readonly) NSArray *activeGoblins;
@property (nonatomic, readonly) NSArray *inactiveGoblins;
@property (nonatomic) CGFloat timeUntilNextGenerate;

- (id)initAtPosition:(CGPoint)position;

+ (int)globalGoblinCap;
+ (void)setGlobalGoblinCap:(int)amount;

- (void)generate;
- (void)recycle:(APAGoblin *)object;

- (void)stopGoblinsFromTargettingHero:(APACharacter *)target;

@end
