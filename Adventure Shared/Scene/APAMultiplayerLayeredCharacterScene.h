/*
     File: APAMultiplayerLayeredCharacterScene.h
 Abstract: n/a
  Version: 1.2
 */


/* The layers in a scene. */
typedef enum : uint8_t {
	APAWorldLayerGround = 0,
	APAWorldLayerBelowCharacter,
	APAWorldLayerCharacter,
	APAWorldLayerAboveCharacter,
	APAWorldLayerTop,
	kWorldLayerCount
} APAWorldLayer;

/* Player states for the four players in the HUD. */
typedef enum : uint8_t {
    APAHUDStateLocal,
    APAHUDStateConnecting,
    APAHUDStateDisconnected,
    APAHUDStateConnected
} APAHUDState;


#define kMinTimeInterval (1.0f / 60.0f)
#define kNumPlayers 4
#define kMinHeroToEdgeDistance 256                  // minimum distance between hero and edge of camera before moving camera

/* Completion handler for callback after loading assets asynchronously. */
typedef void (^APAAssetLoadCompletionHandler)(void);

/* Forward declarations. */
@class APAHeroCharacter, APAPlayer, APACharacter;



@interface APAMultiplayerLayeredCharacterScene : SKScene

@property (nonatomic, readonly) NSArray *players;               // array of player objects or NSNull for no player
@property (nonatomic, readonly) APAPlayer *defaultPlayer;       // player '1' controlled by keyboard/touch
@property (nonatomic, readonly) SKNode *world;                  // root node to which all game renderables are attached
@property (nonatomic) CGPoint defaultSpawnPoint;                // the point at which heroes are spawned
@property (nonatomic) BOOL worldMovedForUpdate;                 // indicates the world moved before or during the current update

@property (nonatomic, readonly) NSArray *heroes;                // all heroes in the game

/* Start loading all the shared assets for the scene in the background. This method calls +loadSceneAssets 
   on a background queue, then calls the callback handler on the main thread. */
+ (void)loadSceneAssetsWithCompletionHandler:(APAAssetLoadCompletionHandler)callback;

/* Overridden by subclasses to load scene-specific assets. */ 
+ (void)loadSceneAssets;

/* Overridden by subclasses to release assets used only by this scene. */
+ (void)releaseSceneAssets;

/* Overridden by subclasses to provide an emitter used to indicate when a new hero is spawned. */
- (SKEmitterNode *)sharedSpawnEmitter;

/* Overridden by subclasses to update the scene - called once per frame. */
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast;

/* This method should be called when the level is loaded to set up currently-connected game controllers,
   and register for the relevant notifications to deal with new connections/disconnections. */
- (void)configureGameControllers;

/* All sprites in the scene should be added through this method to ensure they are placed in the correct world layer. */
- (void)addNode:(SKNode *)node atWorldLayer:(APAWorldLayer)layer;

/* Heroes and players. */
- (APAHeroCharacter *)addHeroForPlayer:(APAPlayer *)player;
- (void)heroWasKilled:(APAHeroCharacter *)hero;

/* Utility methods for coordinates. */
- (void)centerWorldOnCharacter:(APACharacter *)character;
- (void)centerWorldOnPosition:(CGPoint)position;
- (float)distanceToWall:(CGPoint)pos0 from:(CGPoint)pos1;
- (BOOL)canSee:(CGPoint)pos0 from:(CGPoint)pos1;

/* Determines the relevant player from the given projectile, and adds to that player's score. */
- (void)addToScore:(uint32_t)amount afterEnemyKillWithProjectile:(SKNode *)projectile;

@end
