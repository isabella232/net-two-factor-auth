//
//  ViewController.m
//  NumberValidatorSampleApp
//
//  Created by christian jensen on 1/28/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

-(void)viewDidAppear:(BOOL)animated
{
        [[ValidationHelper sharedValidationHelper] startValidation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
