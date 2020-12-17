/*
     File: APAEnemyCharacter.m
 Abstract: n/a
  Version: 1.2
 */

#import "APAEnemyCharacter.h"
#import "APAArtificialIntelligence.h"


@implementation APAEnemyCharacter

#pragma mark - Loop Update
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    [super updateWithTimeSinceLastUpdate:interval];
    
    [self.intelligence updateWithTimeSinceLastUpdate:interval];
}

- (void)animationDidComplete:(APAAnimationState)animationState {
    if (animationState == APAAnimationStateAttack) {
        // Attacking hero should apply same damage as collision with hero, so simply
        // tell the target that we collided with it.
        [self.intelligence.target collidedWith:self.physicsBody];
    }
}


@end
