/*
     File: APAViewController.m
 Abstract: n/a
  Version: 1.2
 
 */

#import "APAViewController.h"
#import "APAAdventureScene.h"

// Uncomment this line to show debug info in the Sprite Kit view:
//#define SHOW_DEBUG_INFO 1

@interface APAViewController ()
@property (nonatomic) IBOutlet SKView *skView;
@property (nonatomic) IBOutlet UIImageView *gameLogo;
@property (nonatomic) IBOutlet UIActivityIndicatorView *loadingProgressIndicator;
@property (nonatomic) IBOutlet UIButton *archerButton;
@property (nonatomic) IBOutlet UIButton *warriorButton;
@property (nonatomic) APAAdventureScene *scene;
@end

@implementation APAViewController

#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    // Start the progress indicator animation.
    [self.loadingProgressIndicator startAnimating];
    
    // Load the shared assets of the scene before we initialize and load it.
    [APAAdventureScene loadSceneAssetsWithCompletionHandler:^{
        CGSize viewSize = self.view.bounds.size;
        
        // On iPhone/iPod touch we want to see a similar amount of the scene as on iPad.
        // So, we set the size of the scene to be double the size of the view, which is
        // the whole screen, 3.5- or 4- inch. This effectively scales the scene to 50%.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            viewSize.height *= 2;
            viewSize.width *= 2;
        }
        
        APAAdventureScene *scene = [[APAAdventureScene alloc] initWithSize:viewSize];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        self.scene = scene;
        
        [scene configureGameControllers];
        
        [self.loadingProgressIndicator stopAnimating];
        [self.loadingProgressIndicator setHidden:YES];
        
        [self.skView presentScene:scene];
        
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.archerButton.alpha = 1.0f;
            self.warriorButton.alpha = 1.0f;
        } completion:NULL];
    }];
#ifdef SHOW_DEBUG_INFO
    // Show debug information.
    self.skView.showsFPS = YES;
    self.skView.showsDrawCount = YES;
    self.skView.showsNodeCount = YES;
#endif
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Rotation
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - UI Display and Actions
- (void)hideUIElements:(BOOL)shouldHide animated:(BOOL)shouldAnimate {
    CGFloat alpha = shouldHide ? 0.0f : 1.0f;
    
    if (shouldAnimate) {
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.gameLogo.alpha = alpha;
            self.archerButton.alpha = alpha;
            self.warriorButton.alpha = alpha;
        } completion:NULL];
    } else {
        [self.gameLogo setAlpha:alpha];
        [self.warriorButton setAlpha:alpha];
        [self.archerButton setAlpha:alpha];
    }
}

- (IBAction)chooseArcher:(id)sender {
    [self startGameWithHeroType:APAHeroTypeArcher];
}

- (IBAction)chooseWarrior:(id)sender {
    [self startGameWithHeroType:APAHeroTypeWarrior];
}

#pragma mark - Starting the Game
- (void)startGameWithHeroType:(APAHeroType)type {
    [self hideUIElements:YES animated:YES];
    [self.scene setDefaultPlayerHeroType:type];
    [self.scene startLevel];
}

@end
