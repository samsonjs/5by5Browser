//
//  Episode.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "Episode.h"

@implementation Episode

@synthesize name = _name;
@synthesize number = _number;
@synthesize url = _url;

+ (id) episodeWithName: (NSString *)name number: (NSString *)number url: (NSURL *)url
{
    return [[self alloc] initWithName: name number: number url: url];
}

- (id) initWithName: (NSString *)name number: (NSString *)number url: (NSURL *)url
{
    self = [super init];
    if (self) {
        self.name = name;
        self.number = number;
        self.url = url;
    }
    return self;
}

@end
