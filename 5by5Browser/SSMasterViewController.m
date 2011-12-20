//
//  SSMasterViewController.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "SSMasterViewController.h"
#import "Show.h"

@implementation SSMasterViewController

@synthesize showViewController = _showViewController;
@synthesize fiveByFive = _fiveByFive;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Shows";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];

    for (int i = 0; i < [self tableView: self.tableView numberOfRowsInSection: 0]; ++i) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: i inSection: 0]];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) setFiveByFive: (FiveByFive *)fiveByFive
{
    _fiveByFive = fiveByFive;
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fiveByFive.shows.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    Show *show = [self.fiveByFive.shows objectAtIndex: indexPath.row];
    show.delegate = self;
    cell.textLabel.text = show.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.fiveByFive.shows objectAtIndex: indexPath.row] getEpisodes];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [indicatorView startAnimating];
    [tableView cellForRowAtIndexPath: indexPath].accessoryView = indicatorView;
}

- (void) gotEpisodesForShow: (Show *)show
{
    self.showViewController.show = show;
    [self.navigationController pushViewController: self.showViewController animated: YES];
}

@end
