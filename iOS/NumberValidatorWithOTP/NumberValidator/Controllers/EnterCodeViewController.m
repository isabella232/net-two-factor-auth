//
//  EnterCodeViewController.m
//  NumberValidator
//
//  Created by christian jensen on 1/28/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "EnterCodeViewController.h"
#import "NSNotificationEvents.h"
#import "HttpClient.h"
#import "ChoosePinViewController.h"

@interface EnterCodeViewController ()
{
    NSString* sharedSecret;
}

@end

@implementation EnterCodeViewController
@synthesize phoneNumber,code, spinner, errorLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [code becomeFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)done:(id)sender {
    [spinner startAnimating];
    errorLabel.text = @"";
    [[HttpClient sharedHttpClient]
     validateCode:phoneNumber
     code:code.text
     completion:^(NSData *data, NSError *error) {
         [self.spinner stopAnimating];
         if (!error)
         {
             //save away the secret
             NSError *JSONError = nil;
             NSDictionary *responseData = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:0
                                           error:&JSONError];
             if (JSONError)
             {
                 NSLog(@"Serialization error: %@", JSONError.localizedDescription);
                 errorLabel.text = @"Invalid code";
             }
             else
             {
                 sharedSecret = [responseData objectForKey:@"secret"];
                 [self performSegueWithIdentifier:@"choosePinSeq" sender:nil];
                 
             }
         }
         else
         {
             errorLabel.text = @"Invalid code";
         }
     }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"choosePinSeq"]) {
        ChoosePinViewController* vc = [segue destinationViewController];
        vc.phoneNumber = self.phoneNumber;
        vc.sharedSecret = sharedSecret;
    }
}


@end
