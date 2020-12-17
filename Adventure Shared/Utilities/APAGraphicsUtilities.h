/*
     File: APAGraphicsUtilities.h
 Abstract: n/a
  Version: 1.2
 */

/* Generate a random float between 0.0f and 1.0f. */
#define APA_RANDOM_0_1() (arc4random() / (float)(0xffffffffu))

/* The assets are all facing Y down, so offset by pi half to get into X right facing. */
#define APA_POLAR_ADJUST(x) x + (M_PI * 0.5f)


/* Load an array of APADataMap or APATreeMap structures for the given map file name. */
void *APACreateDataMap(NSString *mapName);

/* Distance and coordinate utility functions. */
CGFloat APADistanceBetweenPoints(CGPoint first, CGPoint second);
CGFloat APARadiansBetweenPoints(CGPoint first, CGPoint second);
CGPoint APAPointByAddingCGPoints(CGPoint first, CGPoint second);

/* Load the named frames in a texture atlas into an array of frames. */
NSArray *APALoadFramesFromAtlas(NSString *atlasName, NSString *baseFileName, int numberOfFrames);

/* Run the given emitter once, for duration. */
void APARunOneShotEmitter(SKEmitterNode *emitter, CGFloat duration);


/* Define structures that map exactly to 4 x 8-bit ARGB pixel data. */
#pragma pack(1)
typedef struct {
    uint8_t bossLocation, wall, goblinCaveLocation, heroSpawnLocation;
} APADataMap;

typedef struct {
    uint8_t unusedA, bigTreeLocation, smallTreeLocation, unusedB;
} APATreeMap;
#pragma pack()

typedef APADataMap *APADataMapRef;
typedef APATreeMap *APATreeMapRef;


/* Category on NSValue to make it easy to access the pointValue/CGPointValue from iOS and OS X. */
@interface NSValue (APAAdventureAdditions)
- (CGPoint)apa_CGPointValue;
+ (instancetype)apa_valueWithCGPoint:(CGPoint)point;
@end


/* Category on SKEmitterNode to make it easy to load an emitter from a node file created by Xcode. */
@interface SKEmitterNode (APAAdventureAdditions)
+ (instancetype)apa_emitterNodeWithEmitterNamed:(NSString *)emitterFileName;
@end
