//
//  ViewController.m
//  Protractor
//
//  Created by FloodSurge on 7/31/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "InfoViewController.h"
#import "NavigationViewController.h"

#import "GADBannerView.h"
#import "GADRequest.h"

#define ADMOB_ID  @"ca-app-pub-5795175496660185/4979686959"

@implementation ViewController
{
    SKView *skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Configure the view.
    skView = [[SKView alloc] initWithFrame:self.view.frame];
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    NSLog(@"skview x:%f,y:%f,width:%f,height:%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [self.view addSubview:skView];
    
    
    [self addInfoButton];
    //self.canDisplayBannerAds = YES;
    // Admob
    //[self addAdmob];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)addInfoButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        if (self.view.frame.size.height > 500) {
            button.frame = CGRectMake(bounds.size.width/2 - 15,bounds.size.height - 100, 30, 30);
        } else {
            button.frame = CGRectMake(self.view.frame.size.width/2 - 15,self.view.frame.size.height - 90, 30, 30);
        }
        
    } else {
        button.frame = CGRectMake(self.view.frame.size.width/2 - 20,self.view.frame.size.height - 170, 40, 40);
    }
    
    
    [button setImage:[UIImage imageNamed:@"infoButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)showInfo
{
    InfoViewController *infoViewController = [[InfoViewController alloc] init];
    
    NavigationViewController *navController = [[NavigationViewController alloc] initWithRootViewController:infoViewController];
    
    infoViewController.title = NSLocalizedString(@"Info", @"Info");
    navController.navigationBar.barStyle = UIBarStyleDefault;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navController animated:YES completion:nil];
}



#pragma mark - Admob

- (void)addAdmob
{
    // Initialize the banner at the bottom of the screen.
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        CGPoint origin = CGPointMake(0.0,
                                     self.view.frame.size.height -
                                     CGSizeFromGADAdSize(kGADAdSizeBanner).height);
        self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    } else {
        CGPoint origin = CGPointMake((self.view.frame.size.width - CGSizeFromGADAdSize(kGADAdSizeFullBanner).width)/2,
                                     self.view.frame.size.height -
                                     CGSizeFromGADAdSize(kGADAdSizeFullBanner).height);
        self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner origin:origin];
    }
    
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = ADMOB_ID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self request]];
}

#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    
    return request;
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}




@end
