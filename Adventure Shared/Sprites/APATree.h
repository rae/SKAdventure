/*
     File: APATree.h
 Abstract: n/a
  Version: 1.2
 */

#import "APAParallaxSprite.h"

#define kOpaqueDistance 400

@class APAMultiplayerLayeredCharacterScene;


@interface APATree : APAParallaxSprite

@property (nonatomic) BOOL fadeAlpha;

- (void)updateAlphaWithScene:(APAMultiplayerLayeredCharacterScene *)scene;

@end
