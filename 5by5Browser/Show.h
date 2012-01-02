//
//  Show.h
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"
#import "Episode.h"
#import "FiveByFive.h"

@class Episode;

@protocol ShowDelegate <NSObject>
- (void) gotEpisodesForShow: (Show *)show;
@end

@interface Show : NSObject <MWFeedParserDelegate>

@property (nonatomic, assign) id<ShowDelegate> delegate;
@property (nonatomic, retain) FiveByFive *fiveByFive;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *feedPath;
@property (nonatomic, retain) NSString *webPath;
@property (nonatomic, retain) NSMutableArray *episodes;

+ (id) showWithName: (NSString *)name feedPath: (NSString *)feedPath webPath: (NSString *)webPath;
- (id) initWithName: (NSString *)name feedPath: (NSString *)feedPath webPath: (NSString *)webPath;
- (void) addEpisode: (Episode *)episode;
- (void) getEpisodes;
- (NSString *) webURLForEpisodeNumber: (NSString *)episodeNumber;

@end
