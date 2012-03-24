//
//  Episode.h
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Show.h"
#import "MWFeedItem.h"

@class Show;

@interface Episode : NSObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) Show *show;
@property (nonatomic, retain) NSURL *url;

+ (id) episodeWithShow: (Show *)show feedItem: (MWFeedItem *)item;
+ (id) episodeWithShow: (Show *)show name: (NSString *)name number: (NSString *)number date: (NSDate *)date url: (NSURL *)url;
- (id) initWithShow: (Show *)show name: (NSString *)name number: (NSString *)number date: (NSDate *)date url: (NSURL *)url;

@end
