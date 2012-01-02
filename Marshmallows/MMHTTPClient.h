//
//  MMHTTPClient.h
//  Marshmallows
//
//  Created by Sami Samhuri on 11-09-03.
//  Copyright 2011 Guru Logic. All rights reserved.
//

#import <UIKit/UIImage.h>
#import "MMHTTPRequest.h"

@interface MMHTTPClient : NSObject
{
    NSString *_baseURL;
    NSUInteger _timeout;
}

+ (MMHTTPClient *) sharedClient;
+ (id) client;
+ (id) clientWithBaseURL: (NSString *)baseURL;
+ (id) clientWithBaseURL: (NSString *)baseURL timeout: (NSUInteger)timeout;

+ (NSString *) pathFor: (NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString *) urlFor: (NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString *) urlWithPath: (NSString *)path;
+ (MMHTTPRequest *) request: (NSDictionary *)options then: (MMHTTPCallback)callback;
+ (MMHTTPRequest *) get: (NSString *)url then: (MMHTTPCallback)callback;
+ (MMHTTPRequest *) getImage: (NSString *)url then: (MMHTTPImageCallback)callback;
+ (MMHTTPRequest *) getText: (NSString *)url then: (MMHTTPTextCallback)callback;
+ (MMHTTPRequest *) post: (NSString *)url then: (MMHTTPCallback)callback;
+ (MMHTTPRequest *) post: (NSString *)url fields: (NSDictionary *)fields then: (MMHTTPCallback)callback;
+ (MMHTTPRequest *) post: (NSString *)url data: (NSData *)data then: (MMHTTPCallback)callback;
+ (MMHTTPRequest *) put: (NSString *)url data: (NSData *)data then: (MMHTTPCallback)callback;
+ (MMHTTPRequest *) delete: (NSString *)url then: (MMHTTPCallback)callback;

@property (nonatomic, retain) NSString *baseURL;
@property NSUInteger timeout;

- (id) initWithBaseURL: (NSString *)baseURl;
- (id) initWithBaseURL: (NSString *)baseURl timeout: (NSUInteger)timeout;
- (NSString *) pathFor: (NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;
- (NSString *) urlFor: (NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;
- (NSString *) urlWithPath: (NSString *)path;
- (MMHTTPRequest *) request: (NSDictionary *)options then: (MMHTTPCallback)callback;
- (MMHTTPRequest *) get: (NSString *)url then: (MMHTTPCallback)callback;
- (MMHTTPRequest *) getImage: (NSString *)url then: (MMHTTPImageCallback)callback;
- (MMHTTPRequest *) getText: (NSString *)url then: (MMHTTPTextCallback)callback;
- (MMHTTPRequest *) post: (NSString *)url then: (MMHTTPCallback)callback;
- (MMHTTPRequest *) post: (NSString *)url fields: (NSDictionary *)fields then: (MMHTTPCallback)callback;
- (MMHTTPRequest *) post: (NSString *)url data: (NSData *)data then: (MMHTTPCallback)callback;
- (MMHTTPRequest *) put: (NSString *)url data: (NSData *)data then: (MMHTTPCallback)callback;
- (MMHTTPRequest *) delete: (NSString *)url then: (MMHTTPCallback)callback;

@end
