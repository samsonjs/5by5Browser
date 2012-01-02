//
//  UIAlertViewDelegate.h
//  Marshmallows
//
//  Created by Sami Samhuri on 11-09-05.
//  Copyright 2011 Guru Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertView+marshmallows.h"

@interface UIAlertViewDelegate : NSObject <UIAlertViewDelegate>
{
    UIAlertViewCallback _callback;
}

+ (id) alertViewDelegateWithCallback: (UIAlertViewCallback)callback;
- (id) initWithCallback: (UIAlertViewCallback)callback;

@end
