//
//  SSMasterViewController.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "SSMasterViewController.h"
#import "ShowViewController.h"
#import "Show.h"

@implementation SSMasterViewController

@synthesize fiveByFive = _fiveByFive;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"5by5 Shows";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];

    for (int i = 0; i < [self tableView: self.tableView numberOfRowsInSection: 0]; ++i) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: i inSection: 0]];
        cell.accessoryView = nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    Show *show = [self.fiveByFive.shows objectAtIndex: indexPath.row];
    show.delegate = self;
    cell.textLabel.text = show.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.fiveByFive.shows objectAtIndex: indexPath.row] getEpisodes];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    [tableView cellForRowAtIndexPath: indexPath].accessoryView = indicatorView;
}

- (void) gotEpisodesForShow: (Show *)show
{
    ShowViewController *vc;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        vc = [[ShowViewController alloc] initWithNibName: @"ShowViewController_iPhone" bundle: nil];
    }
    else {
        vc = [[ShowViewController alloc] initWithNibName: @"ShowViewController_iPad" bundle: nil];
    }
    vc.show = show;
    [self.navigationController pushViewController: vc animated:YES];
}

@end
