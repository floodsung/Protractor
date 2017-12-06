//
//  ViewController.h
//  Protractor
//

//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#import "GADBannerViewDelegate.h"

@class GADBannerView;
@class GADRequest;

@interface ViewController : UIViewController<GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;


@end
