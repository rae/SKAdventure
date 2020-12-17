/*
     File: APATree.m
 Abstract: n/a
  Version: 1.2
 */

#import "APATree.h"
#import "APAGraphicsUtilities.h"
#import "APAMultiplayerLayeredCharacterScene.h"

@implementation APATree

#pragma mark - Copying
- (id)copyWithZone:(NSZone *)zone {
    APATree *tree = [super copyWithZone:zone];
    if (tree) {
        tree->_fadeAlpha = self.fadeAlpha;
    }
    return tree;
}

#pragma mark - Offsets
- (void)updateAlphaWithScene:(APAMultiplayerLayeredCharacterScene *)scene {
    if (!self.fadeAlpha) {
        return;
    }
    
    CGFloat closestHeroDistance = MAXFLOAT;
    // See if there are any heroes nearby.
    CGPoint ourPosition = self.position;
    for (SKNode *hero in scene.heroes) {
        CGPoint theirPos = hero.position;
        CGFloat distance = APADistanceBetweenPoints(ourPosition, theirPos);
        
        if (distance < closestHeroDistance) {
            closestHeroDistance = distance;
        }
    }
    
    if (closestHeroDistance > kOpaqueDistance) {
        // No heroes nearby.
        self.alpha = 1.0;
    } else {
        // Adjust the alpha based on how close the hero is.
        self.alpha = 0.1 + ((closestHeroDistance / kOpaqueDistance) * (closestHeroDistance / kOpaqueDistance) ) * 0.9;
    }
}

@end
