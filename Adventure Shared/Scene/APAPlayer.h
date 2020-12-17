/*
     File: APAPlayer.h
 Abstract: n/a
  Version: 1.2
 */

@class APAHeroCharacter, GCController;

#define kStartLives 3



@interface APAPlayer : NSObject

@property (nonatomic) APAHeroCharacter *hero;
@property (nonatomic) Class heroClass;

@property (nonatomic) BOOL moveForward;
@property (nonatomic) BOOL moveLeft;
@property (nonatomic) BOOL moveRight;
@property (nonatomic) BOOL moveBack;
@property (nonatomic) BOOL fireAction;

@property (nonatomic) CGPoint heroMoveDirection;

@property (nonatomic) uint8_t livesLeft;
@property (nonatomic) uint32_t score;

@property (nonatomic) GCController *controller;

#if TARGET_OS_IPHONE
@property (nonatomic) UITouch *movementTouch;           // used for iOS to track whether a touch is move or fire action
@property (nonatomic) CGPoint targetLocation;                // used for iOS to track target location
@property (nonatomic) BOOL moveRequested;               // used for iOS to track whether a move was requested
#endif

@end
