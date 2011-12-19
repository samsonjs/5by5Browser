//
//  UIAlertViewDelegate.m
//  Marshmallows
//
//  Created by Sami Samhuri on 11-09-05.
//  Copyright 2011 Guru Logic. All rights reserved.
//

#import "UIAlertViewDelegate.h"

@implementation UIAlertViewDelegate

+ (id) alertViewDelegateWithCallback: (UIAlertViewCallback)callback
{
    return [[self alloc] initWithCallback: callback];
}

- (id) initWithCallback: (UIAlertViewCallback)callback
{
    self = [super init];
    if (self) {
        _callback = callback;
    }
    return self;
}

- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    BOOL ok = (buttonIndex == 1);
    _callback(ok);
}

@end
