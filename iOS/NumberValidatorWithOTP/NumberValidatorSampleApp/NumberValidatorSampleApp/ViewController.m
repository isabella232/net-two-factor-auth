//
//  ViewController.m
//  NumberValidatorSampleApp
//
//  Created by christian jensen on 1/28/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "ViewController.h"
#import <NumberValidatorWithOTP/NumberValidatorWithOTP.h>



@interface ViewController ()

@end

@implementation ViewController
@synthesize validatebutton;

-(void)verificationComplete:(NSNotification*)notification
{
    NSLog(@"number validated %@",[[notification userInfo]
                                  objectForKey:PhoneNumberKey]);
    [validatebutton setTitle:@"Login to website" forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationComplete:) name:NumberValidationDidCompleteNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NumberValidationDidCompleteNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[ValidationHelper sharedValidationHelper] hasInstanceData] == NO)
    {
        [validatebutton setTitle:@"Validate phone" forState:UIControlStateNormal];
    }

        
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)strart2FA:(id)sender {
    if ([[ValidationHelper sharedValidationHelper] hasInstanceData])
        [[ValidationHelper sharedValidationHelper] showTOTP];
    else
        [[ValidationHelper sharedValidationHelper] startValidation];
    
}

- (IBAction)deleteInstanceData:(id)sender {
    [[ValidationHelper sharedValidationHelper] deleteInstanceData];
    [validatebutton setTitle:@"Validate phone" forState:UIControlStateNormal];

}
@end
