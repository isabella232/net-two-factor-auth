//
//  EnterCodeViewController.h
//  NumberValidator
//
//  Created by christian jensen on 1/28/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterCodeViewController : UIViewController
@property NSString* phoneNumber;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end
