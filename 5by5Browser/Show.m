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
@synthesize feedPath = _feedPath;
@synthesize webPath = _webPath;
@synthesize episodes = _episodes;
@synthesize image = _image;

+ (id) showWithName: (NSString *)name feedPath: (NSString *)feedPath webPath: (NSString *)webPath
{
    return [[self alloc] initWithName: name feedPath: feedPath webPath: webPath];
}

- (id) initWithName: (NSString *)name feedPath: (NSString *)feedPath webPath: (NSString *)webPath
{
    self = [super init];
    if (self) {
        self.name = name;
        self.feedPath = feedPath;
        self.webPath = webPath;
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
    return [NSURL URLWithString: [[self.fiveByFive baseURL] stringByAppendingPathComponent: self.feedPath]];
}

- (NSString *) webURLForEpisodeNumber: (NSString *)episodeNumber
{
    return [NSString stringWithFormat: @"http://5by5.tv/%@/%@", self.webPath, episodeNumber];
}

- (UIImage *) image
{
    if (_image == nil) {
        _image = [UIImage imageNamed: [NSString stringWithFormat: @"%@.jpg", self.webPath]];
    }
    return _image;
}

// MWFeedParserDelegate methods

- (void) feedParserDidStart: (MWFeedParser *)parser
{
//    NSLog(@"feed parser started");
}

- (void) feedParser: (MWFeedParser *)parser didParseFeedInfo: (MWFeedInfo *)info
{
//    NSLog(@"feed info: %@", info);
}

- (void) feedParser: (MWFeedParser *)parser didParseFeedItem: (MWFeedItem *)item
{
//    NSLog(@"feed item: %@", item);
    [self addEpisode: [Episode episodeWithShow: self feedItem: item]];
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
