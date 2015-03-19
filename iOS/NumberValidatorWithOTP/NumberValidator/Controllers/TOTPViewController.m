//
//  TOTPViewController.m
//  NumberValidatorWithOTP
//
//  Created by christian jensen on 3/18/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "TOTPViewController.h"
#import "SimpleKeychain.h"
#import "HttpClient.h"
#import "NSNotificationEvents.h"
#import "TOTPGenerator.h"
#import "MF_Base32Additions.h"
@interface TOTPViewController ()

@end

@implementation TOTPViewController
@synthesize spinner, pinCode;
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [pinCode becomeFirstResponder];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString*)generatePin:(NSString*)secret
{
    NSData *secretData =  [NSData dataWithBase32String:secret];
    long timestamp = (long)[[NSDate date] timeIntervalSince1970];
    if(timestamp % 30 != 0){
        timestamp -= timestamp % 30;
    }
    NSInteger digits = 6;
    NSInteger period = 30;
    TOTPGenerator *generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:kOTPGeneratorSHA1Algorithm digits:digits period:period];
    
    NSString *token = [generator generateOTPForDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    NSLog(@"token %@", token);
    return token;
}

- (IBAction)next:(id)sender {
    NSDictionary* data = [SimpleKeychain load:instanceDataKey account:instanceDataKey];
    if ([[data objectForKey:pinCodeKey] isEqualToString:pinCode.text]) //pincode ok
    {
        //generate a totptoken and send to server
        NSString* token = [self generatePin:[data objectForKey:sharedSecretKey]];
        [[HttpClient sharedHttpClient] verifyToken:token
                                   withPhonenumber:[data objectForKey:PhoneNumberKey]
                                        completion:^(NSError *error) {
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }];
    }
    else {
        [[[UIAlertView alloc]
            initWithTitle:@"Wrong pin code"
            message:@"Wrong pincode"
            delegate:nil
            cancelButtonTitle:@"Ok"
            otherButtonTitles:nil] show];
        
    }
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
