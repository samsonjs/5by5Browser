//
//  MMHTTPClient.m
//  Marshmallows
//
//  Created by Sami Samhuri on 11-09-03.
//  Copyright 2011 Guru Logic. All rights reserved.
//

#import "MMHTTPClient.h"
#import "NSString+marshmallows.h"

MMHTTPClient *_client;

NSString *JoinURLComponents(NSString *first, va_list args)
{
    NSMutableString *url = [NSMutableString string];
    NSString *slash = @"";
    for (NSString *arg = first; arg != nil; arg = va_arg(args, NSString *)) {
        [url appendFormat: @"%@%@", slash, [arg stringByURLEncoding]];
        slash = @"/";
    }
    return [NSString stringWithString: url];
}

@implementation MMHTTPClient

@synthesize baseURL = _baseURL;
@synthesize timeout = _timeout;

+ (MMHTTPClient *) sharedClient
{
    if (!_client) {
        _client = [[self alloc] init];
    }
    return _client;
}

+ (id) client
{
    return [[self alloc] init];
}

+ (id) clientWithBaseURL: (NSString *)baseURL
{
    return [[self alloc] initWithBaseURL: baseURL];
}

+ (id) clientWithBaseURL: (NSString *)baseURL timeout: (NSUInteger)timeout
{
    return [[self alloc] initWithBaseURL: baseURL timeout: timeout];
}

+ (NSString *) pathFor: (NSString *)first, ...
{
    va_list args;
    va_start(args, first);
    NSString *url = JoinURLComponents(first, args);
    va_end(args);
    return url;
}

+ (NSString *) urlFor: (NSString *)first, ...
{
    va_list args;
    va_start(args, first);
    NSString *url = [[[self sharedClient] baseURL] stringByAppendingString: JoinURLComponents(first, args)];
    va_end(args);
    return url;
}

+ (NSString *) urlWithPath: (NSString *)path
{
    return [[[self sharedClient] baseURL] stringByAppendingPathComponent: path];
}

+ (MMHTTPRequest *) request: (NSDictionary *)options then: (MMHTTPCallback)callback
{
    return [[self sharedClient] request: options then: callback];
}

+ (MMHTTPRequest *) get: (NSString *)url then: (MMHTTPCallback)callback
{
    return [[self sharedClient] get: url then: callback];
}

+ (MMHTTPRequest *) getImage: (NSString *)url then: (MMHTTPImageCallback)callback
{
    return [[self sharedClient] getImage: url then: callback];
}

+ (MMHTTPRequest *) getText: (NSString *)url then: (MMHTTPTextCallback)callback
{
    return [[self sharedClient] getText: url then: callback];
}

+ (MMHTTPRequest *) post: (NSString *)url then: (MMHTTPCallback)callback
{
    return [[self sharedClient] post: url then: callback];
}

+ (MMHTTPRequest *) post: (NSString *)url fields: (NSDictionary *)fields then: (MMHTTPCallback)callback
{
    return [[self sharedClient] post: url fields: fields then: callback];
}

+ (MMHTTPRequest *) post: (NSString *)url data: (NSData *)data then: (MMHTTPCallback)callback
{
    return [[self sharedClient] post: url data: data then: callback];
}

+ (MMHTTPRequest *) put: (NSString *)url data: (NSData *)data then: (MMHTTPCallback)callback
{
    return [[self sharedClient] put: url data: data then: callback];
}

+ (MMHTTPRequest *) delete: (NSString *)url then: (MMHTTPCallback)callback
{
    return [[self sharedClient] delete: url then: callback];
}

- (id) init
{
    return [self initWithBaseURL: nil timeout: MMHTTPRequestDefaultTimeout];
}

- (id) initWithBaseURL: (NSString *)baseURL
{
    return [self initWithBaseURL: baseURL timeout: MMHTTPRequestDefaultTimeout];
}

- (id) initWithBaseURL: (NSString *)baseURL timeout: (NSUInteger)timeout
{
    self = [super init];
    if (self) {
        _baseURL = [baseURL copy];
        _timeout = timeout;
    }
    return self;
}

- (NSString *) pathFor: (NSString *)first, ...
{
    va_list args;
    va_start(args, first);
    NSString *url = JoinURLComponents(first, args);
    va_end(args);
    return url;
}

- (NSString *) urlFor: (NSString *)first, ...
{
    va_list args;
    va_start(args, first);
    NSString *url = [_baseURL stringByAppendingString: JoinURLComponents(first, args)];
    va_end(args);
    return url;
}

- (NSString *) urlWithPath: (NSString *)path
{
    return [_baseURL stringByAppendingPathComponent: path];
}

- (MMHTTPRequest *) getImage: (NSString *)url then: (MMHTTPImageCallback)callback
{
    return [self request: [NSDictionary dictionary] then: (MMHTTPCallback)callback];
}

- (MMHTTPRequest *) getText: (NSString *)url then: (MMHTTPTextCallback)callback
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             url,     @"url",
                             @"text", @"type",
                             nil];
    return [self request: options then: (MMHTTPCallback)callback];
}

- (MMHTTPRequest *) get: (NSString *)url then: (MMHTTPCallback)callback
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             url,      @"url",
                             @"image", @"type",
                             nil];
    return [self request: options then: (MMHTTPCallback)callback];
}

- (MMHTTPRequest *) post: (NSString *)url then: (MMHTTPCallback)callback
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"POST", @"method",
                             url,     @"url",
                             nil];
    return [self request: options then: callback];
}

- (MMHTTPRequest *) post: (NSString *)url fields: (NSDictionary *)fields then: (MMHTTPCallback)callback
{
    NSMutableArray *parts = [NSMutableArray array];
    NSString *value;
    for (NSString *key in [fields keyEnumerator]) {
        value = [fields objectForKey: key];
        [parts addObject: [NSString stringWithFormat: @"%@=%@", [key stringByURLEncoding], [value stringByURLEncoding]]];
    }
    NSString *body = [parts componentsJoinedByString: @"&"];
    return [self post: url data: [body dataUsingEncoding: NSUTF8StringEncoding] then: callback];
}

- (MMHTTPRequest *) post: (NSString *)url data: (NSData *)data then: (MMHTTPCallback)callback
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"POST", @"method",
                             url,     @"url",
                             data,    @"data",
                             nil];
    return [self request: options then: callback];
}

- (MMHTTPRequest *) put: (NSString *)url data: (NSData *)data then: (MMHTTPCallback)callback
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"PUT",  @"method",
                             url,     @"url",
                             data,    @"data",
                             nil];
    return [self request: options then: callback];
}

- (MMHTTPRequest *) delete: (NSString *)url then: (MMHTTPCallback)callback
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"DELETE", @"method",
                             url,       @"url",
                             nil];
    return [self request: options then: callback];
}

- (MMHTTPRequest *) request: (NSDictionary *)options then: (MMHTTPCallback)callback
{
    NSString *url = [options objectForKey: @"url"];
    NSMutableDictionary *mutableOptions = [options mutableCopy];
    if (_baseURL && !([url hasPrefix: @"http:"] || [url hasPrefix: @"https:"])) {
        [mutableOptions setObject: [self urlWithPath: url] forKey: @"url"];
    }
    NSUInteger timeout = [[options objectForKey: @"timeout"] unsignedIntValue];
    if (timeout == 0) {
        [mutableOptions setValue: [NSNumber numberWithUnsignedInt: self.timeout] forKey: @"timeout"];
    }
    options = [NSDictionary dictionaryWithDictionary: mutableOptions];
    return [MMHTTPRequest requestWithOptions: options callback: callback];
}

@end
