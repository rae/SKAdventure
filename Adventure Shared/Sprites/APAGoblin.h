/*
     File: APAGoblin.h
 Abstract: n/a
  Version: 1.2
 */

#import "APAEnemyCharacter.h"

@class APACave;

@interface APAGoblin : APAEnemyCharacter

- (id)initAtPosition:(CGPoint)position;

@property (nonatomic, weak) APACave *cave;

@end
