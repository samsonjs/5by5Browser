//
//  FiveByFive.h
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Show;

@interface FiveByFive : NSObject

@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSMutableArray *shows;

- (id) initWithBaseURL: (NSString *)baseURL;
- (void) addShow: (Show *)show;
- (Show *) showWithName: (NSString *)name;

@end
