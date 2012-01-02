//
//  FiveByFive.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "FiveByFive.h"
#import "Show.h"

@implementation FiveByFive

@synthesize baseURL = _baseURL;
@synthesize shows = _shows;

- (id) initWithBaseURL: (NSString *)baseURL
{
    self = [super init];
    if (self) {
        self.baseURL = baseURL;
        self.shows = [NSMutableArray array];
    }
    return self;
}

- (void) addShow: (Show *)show
{
    show.fiveByFive = self;
    [self.shows addObject: show];
}

- (Show *) showWithName: (NSString *)name
{
    for (Show *show in self.shows) {
        if ([show.name isEqualToString: name]) return show;
    }
    return nil;
}

@end
