//
//  Episode.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "Episode.h"

@implementation Episode

@synthesize date = _date;
@synthesize name = _name;
@synthesize number = _number;
@synthesize show = _show;
@synthesize url = _url;

+ (id) episodeWithShow: (Show *)show feedItem: (MWFeedItem *)item
{
    return [[self alloc] initWithShow: show name: item.title number: @"<n>" date: item.date url: [NSURL URLWithString: item.link]];
}

+ (id) episodeWithShow: (Show *)show name: (NSString *)name number: (NSString *)number date: (NSDate *)date url: (NSURL *)url
{
    return [[self alloc] initWithShow: show name: name number: number date: date url: url];
}

- (id) initWithShow: (Show *)show name: (NSString *)name number: (NSString *)number date: (NSDate *)date url: (NSURL *)url
{
    self = [super init];
    if (self) {
        self.show = show;
        self.name = name;
        self.number = number;
        self.date = date;
        self.url = url;
    }
    return self;
}

- (void) setName: (NSString *)name
{
    if (self.show && [name hasPrefix: self.show.name]) {
        NSString *showName = [self.show.name stringByAppendingString: @" "];
        name = [name stringByReplacingOccurrencesOfString: showName withString: @""];
    }
    _name = name;
}

@end
