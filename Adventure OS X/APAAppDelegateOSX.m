/*
     File: APAAppDelegateOSX.m
 Abstract: n/a
  Version: 1.2
 
 */

#import "APAAppDelegateOSX.h"
#import "APAAdventureScene.h"

// Uncomment this line to show debug info in the Sprite Kit view:
//#define SHOW_DEBUG_INFO 1

@interface APAAppDelegateOSX ()
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;
@property (nonatomic) APAAdventureScene *scene;

@property (assign) IBOutlet NSImageView *gameLogo;
@property (assign) IBOutlet NSProgressIndicator *loadingProgressIndicator;
@property (assign) IBOutlet NSButton *archerButton;
@property (assign) IBOutlet NSButton *warriorButton;
@end

@implementation APAAppDelegateOSX

#pragma mark - Application Lifecycle
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Start the progress indicator animation.
    [self.loadingProgressIndicator startAnimation:self];
    
    // Load the shared assets of the scene before we initialize and load it.
    [APAAdventureScene loadSceneAssetsWithCompletionHandler:^{
        // The size for the primary scene - 1024x768 is good for OS X and iOS.
        CGSize size = CGSizeMake(1024, 768);
        
        APAAdventureScene *scene = [[APAAdventureScene alloc] initWithSize:size];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        self.scene = scene;
        
        [self.skView presentScene:scene];
        
        [self.loadingProgressIndicator stopAnimation:self];
        [self.loadingProgressIndicator setHidden:YES];
        
        [[NSAnimationContext currentContext] setDuration:2.0f];
        [[self.archerButton animator] setAlphaValue:1.0f];
        [[self.warriorButton animator] setAlphaValue:1.0f];
        
        [scene configureGameControllers];
    }];

#ifdef SHOW_DEBUG_INFO
    // Show debug info in view.
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsDrawCount = YES;
#endif
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

#pragma mark - Actions
- (IBAction)chooseArcher:(id)sender {
    [self startGameWithHeroType:APAHeroTypeArcher];
}

- (IBAction)chooseWarrior:(id)sender {
    [self startGameWithHeroType:APAHeroTypeWarrior];
}

#pragma mark - Starting the Game
- (void)startGameWithHeroType:(APAHeroType)type {
    [[NSAnimationContext currentContext] setDuration:2.0f];
    [[self.gameLogo animator] setAlphaValue:0.0f];
    [[self.warriorButton animator] setAlphaValue:0.0f];
    [[self.archerButton animator] setAlphaValue:0.0f];
    
    [self.scene setDefaultPlayerHeroType:type];
    [self.scene startLevel];
}

@end
