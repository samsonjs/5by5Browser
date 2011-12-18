//
//  Episode.h
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSURL *url;

+ (id) episodeWithName: (NSString *)name number: (NSString *)number url: (NSURL *)url;
- (id) initWithName: (NSString *)name number: (NSString *)number url: (NSURL *)url;

@end
