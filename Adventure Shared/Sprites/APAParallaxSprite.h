/*
     File: APAParallaxSprite.h
 Abstract: n/a
  Version: 1.2
 */


@interface APAParallaxSprite : SKSpriteNode

@property (nonatomic) BOOL usesParallaxEffect;
@property (nonatomic) CGFloat virtualZRotation;

/* If initialized with this method, sprite is set up for parallax effect; otherwise, no parallax. */
- (id)initWithSprites:(NSArray *)sprites usingOffset:(CGFloat)offset;

- (void)updateOffset;

@end
