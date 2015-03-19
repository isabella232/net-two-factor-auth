//
//  ValidationHelper.h
//  NumberValidator
//
//  Created by christian jensen on 1/27/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ValidationHelper : NSObject

+(ValidationHelper *)sharedValidationHelper;
-(void)startValidation;
-(void)showTOTP; //new
@end
