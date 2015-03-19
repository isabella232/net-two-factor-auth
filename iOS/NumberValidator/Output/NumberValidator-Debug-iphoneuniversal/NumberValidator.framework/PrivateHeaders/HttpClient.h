//
//  HttpClient.h
//  NumberValidator
//
//  Created by christian jensen on 1/28/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject
{
 NSURLSession* sessionManager;
}
+(HttpClient*)sharedHttpClient;
-(void)requestCode:(NSString*)phoneNumber completion: (void (^)(NSError *error))completion;

;
-(void)validateCode:(NSString*)phoneNumber :(NSString*)code completion: (void (^)(NSError *error))completion;
;
@end
