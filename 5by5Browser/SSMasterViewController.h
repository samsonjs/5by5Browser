//
//  SSMasterViewController.h
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowViewController.h"
#import "FiveByFive.h"
#import "Show.h"

@interface SSMasterViewController : UITableViewController <ShowDelegate>

@property (nonatomic, retain) FiveByFive *fiveByFive;
@property (nonatomic, retain) ShowViewController *showViewController;
@property (nonatomic, retain) Show *currentShow;
@property (nonatomic, retain) NSString *currentEpisodeNumber;
@property (nonatomic, retain) NSString *currentEpisodeName;
@property (nonatomic, retain) NSTimer *checkNowPlayingTimer;

- (void) checkNowPlaying;

@end
