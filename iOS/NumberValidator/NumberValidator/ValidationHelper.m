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

@implementation ValidationHelper
@synthesize applicationKey;

__strong static ValidationHelper* currentValidationHelperInstance = nil;
+(ValidationHelper *)sharedValidationHelper
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentValidationHelperInstance = [[self alloc] init];
    
    });
    return currentValidationHelperInstance;
}

-(ValidationHelper*)init
{
    self = [super init];
    sessionManager = [NSURLSession sharedSession];
    return self;
}

-(void)startValidation:(NSString*)appKey
{
    applicationKey = appKey;
    UIWindow* window  = [[[UIApplication sharedApplication] delegate] window];
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"com.sinch.NumberValidator"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ValidationStoryBoard" bundle:bundle];
    UINavigationController *vc = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"start"];

    [[window rootViewController] presentViewController:vc animated:true completion:^{
        NSLog(@"presented");
    }];
    
}



@end
