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
#import "NSDate+relative.h"

@implementation SSMasterViewController

@synthesize showViewController = _showViewController;
@synthesize fiveByFive = _fiveByFive;
@synthesize currentShow = _currentShow;
@synthesize currentEpisodeNumber = _currentEpisodeNumber;
@synthesize currentEpisodeName = _currentEpisodeName;
@synthesize checkNowPlayingTimer = _checkNowPlayingTimer;
@synthesize selectedCell = _selectedCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.title = @"Shows";
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
        else {
            self.title = @"5by5";
            [self.navigationItem  setBackBarButtonItem: [[UIBarButtonItem alloc] initWithTitle: @"Shows"
                                                                                         style: UIBarButtonItemStyleBordered
                                                                                        target: self.navigationController
                                                                                        action: @selector(popViewControllerAnimated:)]];
        }
    }
    return self;
}

- (void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];

    UITableViewCell *cell = self.selectedCell;
    if (animated && cell) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.tableView deselectRowAtIndexPath: [self.tableView indexPathForSelectedRow] animated: YES];
    }

    self.checkNowPlayingTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                                 target: self
                                                               selector: @selector(checkNowPlaying)
                                                               userInfo: nil
                                                                repeats: YES];
}

- (void) viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];

    [self.checkNowPlayingTimer invalidate];
    self.checkNowPlayingTimer = nil;
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
        NSString *episodeNumber = [title firstMatch: @"\\d+"];
        NSString *showName = [song valueForProperty: MPMediaItemPropertyAlbumTitle];
        if (![self.currentEpisodeNumber isEqualToString: episodeNumber] && ![self.currentShow.name isEqualToString: showName]) {
            Show *nowPlayingShow = [self.fiveByFive showWithName: showName];
            if (nowPlayingShow) {
                self.currentShow = nowPlayingShow;
                self.currentEpisodeNumber = episodeNumber;
                self.currentEpisodeName = [title substringFromIndex: [title rangeOfString: @": "].location + 2];
                NSLog(@"show: %@, episode: %@, name: %@", showName, self.currentEpisodeNumber, self.currentEpisodeName);
                NSLog(@"show url: %@", [self.currentShow webURLForEpisodeNumber: self.currentEpisodeNumber]);
            }
        }
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }

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
            cell.detailTextLabel.text = [[[[show episodes] objectAtIndex: 0] date]  relativeToNow];
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
        Episode *episode = [Episode episodeWithShow: self.currentShow name: self.currentEpisodeName number: self.currentEpisodeNumber date: nil url: url];
        self.showViewController.detailViewController.episode = episode;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [self.navigationController pushViewController: self.showViewController.detailViewController animated: YES];
        }
    }
    else {
        [[self.fiveByFive.shows objectAtIndex: indexPath.row] getEpisodes];
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        [indicatorView startAnimating];
        self.selectedCell = [tableView cellForRowAtIndexPath: indexPath];
        self.selectedCell.accessoryView = indicatorView;
    }
}

- (void) gotEpisodesForShow: (Show *)show
{
    self.selectedCell.accessoryView = nil;
    self.selectedCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectedCell.detailTextLabel.text = [[[[show episodes] objectAtIndex: 0] date]  relativeToNow];
    self.showViewController.show = show;
    [self.navigationController pushViewController: self.showViewController animated: YES];
}

@end
