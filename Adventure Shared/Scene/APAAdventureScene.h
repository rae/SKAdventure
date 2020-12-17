/*
     File: APAAdventureScene.h
 Abstract: n/a
  Version: 1.2
 */

#import "APAMultiplayerLayeredCharacterScene.h"

#define kWorldTileDivisor 32  // number of tiles
#define kWorldSize 4096       // pixel size of world (square)
#define kWorldTileSize (kWorldSize / kWorldTileDivisor)

#define kWorldCenter 2048

#define kLevelMapSize 256    // pixel size of level map (square)
#define kLevelMapDivisor (kWorldSize / kLevelMapSize)

typedef enum : uint8_t {
    APAHeroTypeArcher,
    APAHeroTypeWarrior
} APAHeroType;

@class APAHeroCharacter;

@interface APAAdventureScene : APAMultiplayerLayeredCharacterScene

- (void)startLevel;
- (void)setDefaultPlayerHeroType:(APAHeroType)heroType;

@end
