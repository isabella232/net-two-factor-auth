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
        //new sessin config
        NSURLSessionConfiguration *sessionConfig =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setHTTPAdditionalHeaders:
         @{@"Accept": @"application/json"}];
        
    });
    return currentHttpClientInstance;
}


-(void)requestCode:(NSString *)phoneNumber completion:(void (^)(NSError * error))completion
{
    sessionManager = [NSURLSession sharedSession];
    NSString* url = [@"http://sinchauthenticator.azurewebsites.net/api/requestCode/" stringByAppendingString:phoneNumber];
[[sessionManager downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
    if (completion)
    {
                 dispatch_async(dispatch_get_main_queue(), ^{
        completion(error);
                 });
    }
    
}] resume];
}

-(void)validateCode:(NSString *)phoneNumber code:(NSString *)code completion:(void (^)(NSData* data, NSError * error))completion{
    sessionManager = [NSURLSession sharedSession];
    NSString* url = [NSString stringWithFormat:@"http://sinchauthenticator.azurewebsites.net/api/verifycode/%@/%@", phoneNumber, code];
    [[sessionManager dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completion)
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(data, error);
            });
    }] resume];
}

-(void)verifyToken:(NSString *)token withPhonenumber:(NSString*)phoneNumber completion:(void (^)(NSError * error))completion
{
    sessionManager = [NSURLSession sharedSession];
    NSString* url = [NSString stringWithFormat:@"http://sinchauthenticator.azurewebsites.net/api/verifytoken?token=%@&phoneNumber=%@", token, phoneNumber];
    NSLog(@"url %@", url);
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [[sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    }] resume];
    
}



@end
