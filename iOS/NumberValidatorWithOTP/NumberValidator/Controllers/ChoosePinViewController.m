//
//  ChoosePinViewController.m
//  NumberValidatorWithOTP
//
//  Created by christian jensen on 3/15/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "ChoosePinViewController.h"
#import "SimpleKeychain.h"
#import "ValidationHelper.h"
#import "NSNotificationEvents.h"
@interface ChoosePinViewController ()

@end

@implementation ChoosePinViewController
@synthesize pinCode, sharedSecret, phoneNumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [pinCode becomeFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)savePin:(id)sender
{
    if (pinCode.text.length < 6)
    {
        [[[UIAlertView alloc] initWithTitle:@"Pin code to short" message:@"Pin code needs to be atleast 6 digits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    ///store both pin and secret securly
    NSDictionary* instanceData = @{pinCodeKey:pinCode.text, sharedSecretKey:sharedSecret, PhoneNumberKey: phoneNumber};
    [SimpleKeychain save:instanceDataKey account:instanceDataKey data:instanceData];
    [[NSNotificationCenter defaultCenter] postNotificationName:NumberValidationDidCompleteNotification object:self userInfo:@{PhoneNumberKey: self.phoneNumber}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
