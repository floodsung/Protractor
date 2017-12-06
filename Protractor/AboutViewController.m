//
//  AboutViewController.m
//  Protractor
//
//  Created by FloodSurge on 7/31/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "AboutViewController.h"
#define ICON_LENGTH_RATE  0.3
@interface AboutViewController ()

@end

@implementation AboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = NSLocalizedString(@"About", @"About");
    
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * (1 - ICON_LENGTH_RATE) / 2, self.view.frame.size.width * (1 - ICON_LENGTH_RATE) / 2, self.view.frame.size.width * ICON_LENGTH_RATE, self.view.frame.size.width * ICON_LENGTH_RATE)];
    
    imageView.image = [UIImage imageNamed:@"AboutIcon"];
    [self.view addSubview:imageView];
    
    float bufferLength = self.view.frame.size.width * (1 - ICON_LENGTH_RATE) / 2 + self.view.frame.size.width * ICON_LENGTH_RATE;
    // Add label
    // 1 Add ProductName
    UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bufferLength + 0.05 * self.view.frame.size.width, self.view.frame.size.width, 30)];
    productLabel.backgroundColor = [UIColor clearColor];
    productLabel.textColor = [UIColor blackColor];
    productLabel.textAlignment = NSTextAlignmentCenter;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        productLabel.font = [UIFont boldSystemFontOfSize:20];
    } else {
        productLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    
    productLabel.text = NSLocalizedString(@"Protractor", @"Protractor");
    [self.view addSubview:productLabel];
    
    // 2 add Version
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bufferLength + 0.13 * self.view.frame.size.width, self.view.frame.size.width * 0.8, 20)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor blackColor];
    versionLabel.textAlignment = NSTextAlignmentRight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        versionLabel.font = [UIFont boldSystemFontOfSize:17];
    } else {
        versionLabel.font = [UIFont boldSystemFontOfSize:22];
    }
   
    
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"V %@",versionString];
    [self.view addSubview:versionLabel];
    
    // 3 add category
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bufferLength + 0.20 * self.view.frame.size.width, self.view.frame.size.width, 140)];
    categoryLabel.backgroundColor = [UIColor clearColor];
    categoryLabel.textColor = [UIColor blackColor];
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    categoryLabel.numberOfLines = 4;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        categoryLabel.font = [UIFont systemFontOfSize:18];
    } else {
        categoryLabel.font = [UIFont systemFontOfSize:22];
    }
    
    categoryLabel.text = NSLocalizedString(@"Made by Flood Surge", @"Made");
    [self.view addSubview:categoryLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
