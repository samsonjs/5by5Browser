//
//  SSMasterViewController.h
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiveByFive.h"
#import "Show.h"

@interface SSMasterViewController : UITableViewController <ShowDelegate>

@property (nonatomic, retain) FiveByFive *fiveByFive;

@end
