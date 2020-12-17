/*
     File: APAPlayer.m
 Abstract: n/a
  Version: 1.2
 */

#import "APAPlayer.h"

@implementation APAPlayer

#pragma mark - Initialization
- (id)init {
    self = [super init];
    if (self) {
        _livesLeft = kStartLives;
    
        // Pick one of the two hero classes at random.
        if ((arc4random_uniform(2)) == 0) {
            _heroClass = NSClassFromString(@"APAWarrior");
        } else {
            _heroClass = NSClassFromString(@"APAArcher");
        }
    }
    return self;
}

@end
