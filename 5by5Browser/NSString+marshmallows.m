//
//  NSString+marshmallows.m
//  Marshmallows
//
//  Created by Sami Samhuri on 11-09-03.
//  Copyright 2011 Guru Logic. All rights reserved.
//

#import "NSString+marshmallows.h"

// Encode a string to embed in an URL.
NSString* URLEncode(NSString *string) {
    return (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}


@implementation NSString (NSString_marshmallows)

- (NSString *) stringByTrimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) firstMatch: (NSString *)pattern
{
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern: pattern
                                  options: 0
                                  error: NULL];
    NSRange match = [regex rangeOfFirstMatchInString: self
                                             options: NSMatchingCompleted
                                               range: NSMakeRange(0, self.length)];
    return match.location == NSNotFound ? nil : [self substringWithRange: match];
}

- (NSString *) stringByReplacing: (NSString *)pattern with: (NSString *)replacement
{
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern: pattern
                                  options: NSRegularExpressionCaseInsensitive
                                  error: NULL];
    return [regex stringByReplacingMatchesInString: self
                                           options: NSMatchingCompleted
                                             range: NSMakeRange(0, [self length])
                                      withTemplate: @""];
}

- (NSString *) stringByReplacingFirst: (NSString *)pattern with: (NSString *)replacement
{
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern: pattern
                                  options: 0
                                  error: NULL];
    NSRange match = [regex rangeOfFirstMatchInString: self
                                             options: NSMatchingCompleted
                                               range: NSMakeRange(0, self.length)];
    if (match.location != NSNotFound) {
        NSString *rest = [self substringFromIndex: match.location + match.length];
        return [[[self substringToIndex: match.location]
                 stringByAppendingString: replacement]
                stringByAppendingString: rest];
    }
    return [self copy];
}

- (NSString *) stringByURLEncoding
{
    return URLEncode(self);
}

@end
