/*
     File: APASpawnAI.m
 Abstract: n/a
  Version: 1.2
 */

#import "APASpawnAI.h"
#import "APACave.h"
#import "APAMultiplayerLayeredCharacterScene.h"
#import "APAGraphicsUtilities.h"

#define kMinimumHeroDistance 2048

@implementation APASpawnAI

#pragma mark - Loop Update
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    APACave *cave = (id)self.character;
    
    if (cave.health <= 0.0f) {
        return;
    }
    
    APAMultiplayerLayeredCharacterScene *scene = [cave characterScene];
    
    CGFloat closestHeroDistance = kMinimumHeroDistance;
    CGPoint closestHeroPosition = CGPointZero;
    
    CGPoint cavePosition = cave.position;
    for (SKNode *hero in scene.heroes) {
        CGPoint heroPosition = hero.position;
        CGFloat distance = APADistanceBetweenPoints(cavePosition, heroPosition);
        if (distance < closestHeroDistance) {
            closestHeroDistance = distance;
            closestHeroPosition = heroPosition;
        }
    }
    
    CGFloat distScale = (closestHeroDistance / kMinimumHeroDistance);
    
    // Generate goblins more quickly if the closest hero is getting closer.
    cave.timeUntilNextGenerate -= interval;
    
    // Either time to generate or the hero is so close we need to respond ASAP!
    NSUInteger goblinCount = [cave.activeGoblins count];
    if (goblinCount < 1 || cave.timeUntilNextGenerate <= 0.0f || (distScale < 0.35f && cave.timeUntilNextGenerate > 5.0f)) {
        if (goblinCount < 1 || (goblinCount < 4 && !CGPointEqualToPoint(closestHeroPosition, CGPointZero) && [scene canSee:closestHeroPosition from:cave.position])) {
            [cave generate];
        }
        cave.timeUntilNextGenerate = (4.0f * distScale);
    }
}

@end
