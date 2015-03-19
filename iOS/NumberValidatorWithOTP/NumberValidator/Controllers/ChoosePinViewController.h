//
//  ChoosePinViewController.h
//  NumberValidatorWithOTP
//
//  Created by christian jensen on 3/15/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePinViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *pinCode;
@property NSString* sharedSecret;
@property NSString* phoneNumber;
- (IBAction)savePin:(id)sender;
@end
