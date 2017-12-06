//
//  InfoViewController.m
//  Protractor
//
//  Created by FloodSurge on 7/31/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "InfoViewController.h"
#import <MessageUI/MessageUI.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AboutViewController.h"

@interface InfoViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation InfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
        self.navigationItem.leftBarButtonItem = shareButton;

        
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        
        self.navigationItem.rightBarButtonItem = doneButton;

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Tutorial", @"Tutorial");
            cell.imageView.image = [UIImage imageNamed:@"Tutorial"];

            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Feedback", @"Feedback");
            cell.imageView.image = [UIImage imageNamed:@"Feedback"];

            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"Rate", @"Rate");
            cell.imageView.image = [UIImage imageNamed:@"Rate"];

            break;
        case 3:
            cell.textLabel.text = NSLocalizedString(@"About", @"About");
            cell.imageView.image = [UIImage imageNamed:@"About"];

            break;
            
        default:
            break;
    }
    
    return cell;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            
            NSString *url = [[NSBundle mainBundle] pathForResource:@"Tutorial" ofType:@"mov"];
            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
            
        
            }
            break;
        case 1:
        {
            // Feedback
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                //picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            }
            
            picker.mailComposeDelegate = self;
            [picker setToRecipients:[NSArray arrayWithObjects:@"songrotek@qq.com", nil]];
            [picker setSubject:NSLocalizedString(@"Feedback", @"Feedback")];
            
            [self presentViewController:picker animated:YES completion:nil];
            [self.tableView reloadData];
        }
            break;
        case 2:
            // Rate
        {
            NSString *str = @"itms-apps://itunes.apple.com/app/id905725107";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [self.tableView reloadData];
        }

            break;
        case 3:
            // About
        {
            AboutViewController *aboutViewController = [[AboutViewController alloc] init];
            aboutViewController.navigationController.title = NSLocalizedString(@"About", @"About");
            [self.navigationController pushViewController:aboutViewController animated:YES];
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - mail compose view controller delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)share:(UIBarButtonItem *)sender
{
    NSString *initialString = NSLocalizedString(@"Protractor is a Great App! Have Fun with it!", @"Share");
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/protractor-your-must-have/id905725107?ls=1&mt=8"];
    UIImage *showImage = [UIImage imageNamed:@"share"];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[initialString,url,showImage] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)done:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
