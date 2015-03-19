//
//  EnterPhoneNumberViewController.h
//  NumberValidator
//
//  Created by christian jensen on 1/27/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EnterPhoneNumberViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
