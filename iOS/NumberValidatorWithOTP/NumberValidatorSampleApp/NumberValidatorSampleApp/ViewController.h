//
//  ViewController.h
//  NumberValidatorSampleApp
//
//  Created by christian jensen on 1/28/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

- (IBAction)strart2FA:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *validatebutton;

- (IBAction)deleteInstanceData:(id)sender;

@end

