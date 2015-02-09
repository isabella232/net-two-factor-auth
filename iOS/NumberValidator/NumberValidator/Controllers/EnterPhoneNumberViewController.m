//
//  EnterPhoneNumberViewController.m
//  NumberValidator
//
//  Created by christian jensen on 1/27/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "EnterPhoneNumberViewController.h"
#import "NSNotificationEvents.h"
#import "EnterCodeViewController.h"
#import "HttpClient.h"
@interface EnterPhoneNumberViewController ()

@end

@implementation EnterPhoneNumberViewController
@synthesize phoneNumber, errorLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [phoneNumber becomeFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    [self.spinner startAnimating];
    errorLabel.text = @"";
    [[HttpClient sharedHttpClient] requestCode:self.phoneNumber.text completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            [phoneNumber resignFirstResponder];
            if (error == nil)
            {
                
                [self performSegueWithIdentifier:@"enterCode" sender:nil];
                
            }
            else
            {
                errorLabel.text = @"Something went wrong";
                //show some error message
            }
        });
        
        
    }];
}

- (IBAction)cancel:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NumberValidationDidCompleteNotification object:nil];
    [[self parentViewController] dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"enterCode"])
    {
        EnterCodeViewController* vc = [segue destinationViewController];
        vc.phoneNumber = self.phoneNumber.text;
    }
}


@end
