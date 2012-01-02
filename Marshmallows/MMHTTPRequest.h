//
//  MMHTTPRequest.h
//  Marshmallows
//
//  Created by Sami Samhuri on 11-09-03.
//  Copyright 2011 Guru Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

#define MMHTTPRequestStatusError -1
#define MMHTTPRequestDefaultTimeout 120

typedef void (^MMHTTPCallback)(NSInteger status, id data);
typedef void (^MMHTTPTextCallback)(NSInteger status, NSString *text);
typedef void (^MMHTTPImageCallback)(NSInteger status, UIImage *image);

@interface MMHTTPRequest : NSObject
{
    NSMutableData *_responseData;
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableDictionary *headers;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, copy) MMHTTPCallback callback;
@property NSUInteger timeout;
@property (readonly) NSInteger statusCode;
@property (readonly) NSDictionary *responseHeaders;
@property (readonly) NSData *responseData;
@property (readonly) NSString *responseText;
@property (readonly) UIImage *responseImage;

+ (id) requestWithOptions: (NSDictionary *)options callback: (MMHTTPCallback)callback;
- (id) initWithOptions: (NSDictionary *)options callback: (MMHTTPCallback)callback;
- (void) cancel;

@end
