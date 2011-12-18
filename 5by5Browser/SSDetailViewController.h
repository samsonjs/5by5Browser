//
//  SSDetailViewController.h
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"

@interface SSDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) Episode *episode;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButton;

- (IBAction) goHome;

@end
