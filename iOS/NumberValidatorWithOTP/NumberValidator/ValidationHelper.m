//
//  ValidationHelper.m
//  NumberValidator
//
//  Created by christian jensen on 1/27/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "ValidationHelper.h"
#import "EnterPhoneNumberViewController.h"

NSString* const NumberValidationDidCompleteNotification = @"NumberValidationDidCompleteNotification";
NSString* const NumberValidationDidCancelNotification= @"NumberValidationDidCancelNotification";
NSString* const PhoneNumberKey= @"PhoneNumberKey";
NSString* const pinCodeKey= @"pinCode";
NSString* const sharedSecretKey = @"sharedSecret";
NSString* const instanceDataKey = @"instanceData";

@implementation ValidationHelper

__strong static ValidationHelper* currentValidationHelperInstance = nil;
+(ValidationHelper *)sharedValidationHelper
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentValidationHelperInstance = [[self alloc] init];
    
    });
    return currentValidationHelperInstance;
}
-(void)showTOTP
{
    UIWindow* window  = [[[UIApplication sharedApplication] delegate] window];
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"com.sinch.NumberValidatorWithOTP"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TOTP" bundle:bundle];
    UINavigationController *vc = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"totp"];
    [vc setNavigationBarHidden:NO];
    [[window rootViewController] presentViewController:vc animated:true completion:^{
        NSLog(@"presented");
    }];
}

-(void)startValidation
{
    UIWindow* window  = [[[UIApplication sharedApplication] delegate] window];
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"com.sinch.NumberValidatorWithOTP"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ValidationStoryBoard" bundle:bundle];
    UINavigationController *vc = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"start"];
    [vc setNavigationBarHidden:NO];
    [[window rootViewController] presentViewController:vc animated:true completion:^{
        NSLog(@"presented");
    }];
    
}



@end
