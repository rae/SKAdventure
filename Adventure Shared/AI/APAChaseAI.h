/*
     File: APAChaseAI.h
 Abstract: n/a
  Version: 1.2
 */

#import "APAArtificialIntelligence.h"

#define kEnemyAlertRadius (kCharacterCollisionRadius * 500)


@interface APAChaseAI : APAArtificialIntelligence

@property (nonatomic) CGFloat chaseRadius;
@property (nonatomic) CGFloat maxAlertRadius;

@end
