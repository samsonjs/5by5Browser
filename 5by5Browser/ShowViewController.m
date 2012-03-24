//
//  ShowViewController.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "ShowViewController.h"
#import "SSDetailViewController.h"
#import "Episode.h"
#import "NSDate+relative.h"

@interface ShowViewController ()
@property (nonatomic, retain) NSMutableDictionary *indexPaths;
@end

@implementation ShowViewController

@synthesize detailViewController = _detailViewController;
@synthesize show = _show;
@synthesize indexPaths = _indexPaths;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
            self.indexPaths = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.show) {
        [self configureView];
    }
}

- (void) viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.indexPaths setObject: [[self.tableView indexPathsForVisibleRows] objectAtIndex: 0] forKey: self.show.name];
}

- (void) configureView
{
    self.title = self.show.name;
    NSIndexPath *indexPath = [self.indexPaths objectForKey: self.show.name];
    if (!indexPath) {
        indexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    }
    [self.tableView scrollToRowAtIndexPath: indexPath atScrollPosition: UITableViewScrollPositionTop animated: NO];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) setShow: (Show *)show
{
    _show = show;
    [self configureView];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.show.episodes.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    Episode *episode = [self.show.episodes objectAtIndex: indexPath.row];
    cell.textLabel.text = episode.name;
    cell.detailTextLabel.text = [episode.date relativeToNow];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Episode *episode = [self.show.episodes objectAtIndex: indexPath.row];
    self.detailViewController.episode = episode;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController: self.detailViewController animated: YES];
    }
}

@end
