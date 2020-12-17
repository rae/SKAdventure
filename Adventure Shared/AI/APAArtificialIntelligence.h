/*
     File: APAArtificialIntelligence.h
 Abstract: n/a
  Version: 1.2
 */

@class APACharacter;

@interface APAArtificialIntelligence : NSObject

@property (nonatomic, weak) APACharacter *character;
@property (nonatomic, weak) APACharacter *target;

- (id)initWithCharacter:(APACharacter *)character target:(APACharacter *)target;

- (void)clearTarget:(APACharacter *)target;

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;

@end
