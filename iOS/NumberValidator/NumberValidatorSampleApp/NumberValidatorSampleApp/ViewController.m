//
//  ViewController.m
//  NumberValidatorSampleApp
//
//  Created by christian jensen on 1/28/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "ViewController.h"
#import <NumberValidator/NumberValidator.h>

@interface ViewController ()

@end

@implementation ViewController

-(void)verificationComplete:(NSNotification*)notification
{
    NSLog(@"number validated %@",[[notification userInfo]
                                  objectForKey:PhoneNumberKey]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationComplete:) name:NumberValidationDidCompleteNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NumberValidationDidCompleteNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)validate:(id)sender {
    [[ValidationHelper sharedValidationHelper] startValidation];
}


@end
