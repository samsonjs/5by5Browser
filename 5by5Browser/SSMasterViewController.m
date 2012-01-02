//
//  SSMasterViewController.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "SSMasterViewController.h"
#import "Show.h"
#import "NSString+marshmallows.h"

@implementation SSMasterViewController

@synthesize showViewController = _showViewController;
@synthesize fiveByFive = _fiveByFive;
@synthesize currentShow = _currentShow;
@synthesize currentEpisodeNumber = _currentEpisodeNumber;
@synthesize currentEpisodeName = _currentEpisodeName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"5by5";
        [self.navigationItem  setBackBarButtonItem: [[UIBarButtonItem alloc] initWithTitle: @"Shows"
                                                                                     style: UIBarButtonItemStyleBordered
                                                                                    target: self.navigationController
                                                                                    action: @selector(popViewControllerAnimated:)]];
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

    [self checkNowPlaying];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) checkNowPlaying
{
    // Determine of the current playing track is a known show
    MPMediaItem *song = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
    if (song) {
        NSString *title = [song valueForProperty: MPMediaItemPropertyTitle];
        self.currentEpisodeNumber = [title firstMatch: @"\\d+"];
        self.currentEpisodeName = [title substringFromIndex: [title rangeOfString: @": "].location + 2];
        NSString *showName = [song valueForProperty: MPMediaItemPropertyAlbumTitle];
        self.currentShow = [self.fiveByFive showWithName: showName];
        if (self.currentShow) {
            NSLog(@"show: %@, episode: %@, name: %@", showName, self.currentEpisodeNumber, self.currentEpisodeName);
            NSLog(@"show url: %@", [self.currentShow webURLForEpisodeNumber: self.currentEpisodeNumber]);
        }
        else {
            NSLog(@"no show named %@", showName);
        }
    }
    else {
        NSLog(@"no song is currently playing");
    }
    [self.tableView reloadData];
}

- (void) setFiveByFive: (FiveByFive *)fiveByFive
{
    _fiveByFive = fiveByFive;
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.currentShow ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentShow && section == 0) {
        return 1;
    }
    else {
        return self.fiveByFive.shows.count;
    }
}

- (NSString *) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    if (self.currentShow && section == 0) {
        return @"Now Playing";
    }
    return @"Shows";
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 60.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (self.currentShow && indexPath.section == 0) {
        self.currentShow.delegate = self;
        cell.textLabel.text = self.currentEpisodeName;
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ %@", self.currentShow.name, self.currentEpisodeNumber];
        cell.imageView.image = self.currentShow.image;
    }
    else {
        Show *show = [self.fiveByFive.shows objectAtIndex: indexPath.row];
        show.delegate = self;
        cell.textLabel.text = show.name;
        cell.imageView.image = show.image;
        if (show.episodes.count > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat: @"%d episodes", show.episodes.count];
        }
        else {
            cell.detailTextLabel.text = nil;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentShow && indexPath.section == 0) {
        NSURL *url = [NSURL URLWithString: [self.currentShow webURLForEpisodeNumber: self.currentEpisodeNumber]];
        Episode *episode = [Episode episodeWithShow: self.currentShow name: self.currentEpisodeName number: self.currentEpisodeNumber url: url];
        self.showViewController.detailViewController.episode = episode;
        [self.navigationController pushViewController: self.showViewController.detailViewController animated: YES];
    }
    else {
        [[self.fiveByFive.shows objectAtIndex: indexPath.row] getEpisodes];
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        [indicatorView startAnimating];
        [tableView cellForRowAtIndexPath: indexPath].accessoryView = indicatorView;
    }
}

- (void) gotEpisodesForShow: (Show *)show
{
    self.showViewController.show = show;
    [self.navigationController pushViewController: self.showViewController animated: YES];
}

@end
