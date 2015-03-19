//
//  HttpClient.m
//  NumberValidator
//
//  Created by christian jensen on 1/28/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "HttpClient.h"
#import "ValidationHelper.h"
@implementation HttpClient
__strong static HttpClient* currentHttpClientInstance = nil;
+(HttpClient *)sharedHttpClient
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentHttpClientInstance = [[self alloc] init];
        currentHttpClientInstance->sessionManager = [NSURLSession sharedSession];
        
    });
    return currentHttpClientInstance;
}


-(void)requestCode:(NSString *)phoneNumber completion:(void (^)(NSError *))completion
{
    sessionManager = [NSURLSession sharedSession];
    NSString* url = [@"http://www.numberReputation.com/api/verify?phoneNumber=" stringByAppendingString:phoneNumber];
    url = [[url stringByAppendingString:@"&applicationKey="] stringByAppendingString:[ValidationHelper sharedValidationHelper].applicationKey];
    [[sessionManager downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (completion)
        {
            completion(error);
        }
        
    }] resume];
}

-(void)validateCode:(NSString *)phoneNumber :(NSString *)code completion:(void (^)(NSError *))completion{
    sessionManager = [NSURLSession sharedSession];
    NSString* url = [NSString stringWithFormat:@"http://www.numberReputation.com/api/verify?phoneNumber=%@&code=%@", phoneNumber, code];
    url = [[url stringByAppendingString:@"&applicationKey="] stringByAppendingString:[ValidationHelper sharedValidationHelper].applicationKey];
    [[sessionManager downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (completion)
            completion(error);
    }] resume];
}


@end
