//
//  UIAlertView+marshmallows.h
//  DatingX
//
//  Created by Sami Samhuri on 11-08-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewCallback)(BOOL ok);

@interface UIAlertView (UIAlertView_marshmallows)

+ (void) showAlertWithTitle: (NSString *)title message: (NSString *)message;

@end
