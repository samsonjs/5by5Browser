//
//  NSDate+relative.m
//  DatingX
//
//  Created by Sami Samhuri on 11-08-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+relative.h"

#define MINUTE 60.0
#define HOUR   (60.0 * MINUTE)
#define DAY    (24.0 * HOUR)
#define WEEK   (7.0 * DAY)
#define MONTH  (30.0 * DAY)

@implementation NSDate (NSDate_relative)

- (NSString *) relativeToNow
{
    double diff = [[NSDate date] timeIntervalSinceDate: self];
    if (diff < MINUTE) {
        return @"right now";
    }
    else if (diff < 2 * MINUTE) {
        return @"a minute ago";
    }
    else if (diff < HOUR) {
        return [NSString stringWithFormat: @"%d minutes ago", (int)(diff / MINUTE)];
    }
    else if (diff < 2 * HOUR) {
        return @"an hour ago";
    }
    else if (diff < DAY) {
        return [NSString stringWithFormat: @"%d hours ago", (int)(diff / HOUR)];
    }
    else if (diff < 2 * DAY) {
        return @"yesterday";
    }
    else if (diff < WEEK) {
        return [NSString stringWithFormat: @"%d days ago", (int)(diff / DAY)];
    }
    else if (diff < 2 * WEEK) {
        return @"last week";
    }
    else if (diff < 4 * WEEK) {
        return [NSString stringWithFormat: @"%d weeks ago", (int)(diff / WEEK)];
    }
    else if (diff < 8 * WEEK) {
        return @"last month";
    }
    else if (diff < 12 * MONTH) {
        return [NSString stringWithFormat: @"%d months ago", (int)(diff / MONTH)];
    }
    else {
        return @"a long time ago";
    }   
}

@end
