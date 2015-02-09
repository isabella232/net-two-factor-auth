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
@interface EnterCodeViewController ()

@end

@implementation EnterCodeViewController
@synthesize phoneNumber,code, spinner, errorLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)done:(id)sender {
    [spinner startAnimating];
    errorLabel.text = @"";
    [[HttpClient sharedHttpClient] validateCode:phoneNumber :code.text completion:^(NSError *error) {
        [self.spinner stopAnimating];
        if (!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:VALIDATION_COMPLETE object:self.phoneNumber];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            errorLabel.text = @"Invalid code";
        }
        
    }];
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
