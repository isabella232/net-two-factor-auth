//
//  TOTPViewController.h
//  NumberValidatorWithOTP
//
//  Created by christian jensen on 3/18/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOTPViewController : UIViewController
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *pinCode;
- (IBAction)cancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
