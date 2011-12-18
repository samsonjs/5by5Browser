//
//  ShowViewController.h
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSDetailViewController.h"
#import "Show.h"

@interface ShowViewController : UITableViewController

@property (strong, nonatomic) SSDetailViewController *detailViewController;
@property (nonatomic, retain) Show *show;

@end
