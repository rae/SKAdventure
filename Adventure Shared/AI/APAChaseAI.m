/*
     File: APAChaseAI.m
 Abstract: n/a
  Version: 1.2
 */

#import "APAChaseAI.h"
#import "APACharacter.h"
#import "APAGraphicsUtilities.h"
#import "APAPlayer.h"
#import "APAMultiplayerLayeredCharacterScene.h"
#import "APAHeroCharacter.h"

@implementation APAChaseAI

#pragma mark - Initialization
- (id)initWithCharacter:(APACharacter *)character target:(APACharacter *)target {
    self = [super initWithCharacter:character target:target];
    if (self) {
        _maxAlertRadius = (kEnemyAlertRadius * 2.0f);
        _chaseRadius = (kCharacterCollisionRadius * 2.0f);
    }
    return self;
}

#pragma mark - Loop Update
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    APACharacter *ourCharacter = self.character;
    
    if (ourCharacter.dying) {
        self.target = nil;
        return;
    }
    
    CGPoint position = ourCharacter.position;
    APAMultiplayerLayeredCharacterScene *scene = [ourCharacter characterScene];
    CGFloat closestHeroDistance = MAXFLOAT;
    
    // Find the closest living hero, if any, within our alert distance.
    for (APAHeroCharacter *hero in scene.heroes) {
        CGPoint heroPosition = hero.position;
        CGFloat distance = APADistanceBetweenPoints(position, heroPosition);
        if (distance < kEnemyAlertRadius && distance < closestHeroDistance && !hero.dying) {
            closestHeroDistance = distance;
            self.target = hero;
        }
    }
    
    // If there's no target, don't do anything.
    APACharacter *target = self.target;
    if (!target) {
        return;
    }
    
    // Otherwise chase or attack the target, if it's near enough.
    CGPoint heroPosition = target.position;
    CGFloat chaseRadius = self.chaseRadius;
    
    if (closestHeroDistance > self.maxAlertRadius) {
        self.target = nil;
    } else if (closestHeroDistance > chaseRadius) {
        [self.character moveTowards:heroPosition withTimeInterval:interval];
    } else if (closestHeroDistance < chaseRadius) {
        [self.character faceTo:heroPosition];
        [self.character performAttackAction];
    }
}

@end
