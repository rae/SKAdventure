/*
     File: APAArtificialIntelligence.m
 Abstract: n/a
  Version: 1.2
 */

#import "APAArtificialIntelligence.h"

@implementation APAArtificialIntelligence

#pragma mark - Initialization
- (id)initWithCharacter:(APACharacter *)character target:(APACharacter *)target {
    self = [super init];
    if (self) {
        _character = character;
        _target = target;
    }
    return self;
}

#pragma mark - Loop Update
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    /* Overridden by subclasses. */
}

#pragma mark - Targets
- (void)clearTarget:(APACharacter *)target {
    if (self.target == target) {
        self.target = nil;
    }
}

@end
