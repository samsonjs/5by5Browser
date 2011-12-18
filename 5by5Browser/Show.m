//
//  Show.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "Show.h"
#import "MWFeedParser.h"

// Private API
@interface Show ()
- (NSURL *) feedURL;
@end


@implementation Show

@synthesize delegate = _delegate;
@synthesize fiveByFive = _fiveByFive;
@synthesize name = _name;
@synthesize path = _path;
@synthesize episodes = _episodes;

+ (id) showWithName: (NSString *)name path: (NSString *)path
{
    return [[self alloc] initWithName: name path: path];
}

- (id) initWithName: (NSString *)name path: (NSString *)path
{
    self = [super init];
    if (self) {
        self.name = name;
        self.path = path;
        self.episodes = [NSMutableArray array];
    }
    return self;
}

- (void) getEpisodes
{
    if (self.episodes.count == 0) {
        MWFeedParser *parser = [[MWFeedParser alloc] initWithFeedURL: [self feedURL]];
        parser.delegate = self;
        parser.feedParseType = ParseTypeFull;
        parser.connectionType = ConnectionTypeAsynchronously;
        [parser parse];
    }
    else {
        [self.delegate gotEpisodesForShow: self];
    }
}

- (void) addEpisode: (Episode *)episode
{
    [self.episodes addObject: episode];
}

- (NSURL *) feedURL
{
    return [NSURL URLWithString: [[self.fiveByFive baseURL] stringByAppendingPathComponent: self.path]];
}


// MWFeedParserDelegate methods

- (void) feedParserDidStart: (MWFeedParser *)parser
{
    NSLog(@"feed parser started");
}

- (void) feedParser: (MWFeedParser *)parser didParseFeedInfo: (MWFeedInfo *)info
{
    NSLog(@"feed info: %@", info);
}

- (void) feedParser: (MWFeedParser *)parser didParseFeedItem: (MWFeedItem *)item
{
    NSLog(@"feed item: %@", item);
    [self addEpisode: [Episode episodeWithName: item.title number: @"<n>" url: [NSURL URLWithString: item.link]]];
}

- (void) feedParserDidFinish: (MWFeedParser *)parser
{
    [self.delegate gotEpisodesForShow: self];
}

- (void) feedParser: (MWFeedParser *)parser didFailWithError: (NSError *)error
{
    NSLog(@"feed parser error: %@", error);
}

@end
