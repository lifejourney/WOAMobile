//
//  WOAHTTPRequester.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAHTTPRequester.h"

@implementation WOAHTTPRequester

+ (NSMutableURLRequest*) URLRequestWithBodyData: (NSData*)bodyData
{
    NSString *urlString = @"http://220.162.12.167:8080/?action=app";
    NSString *httpMethod = @"POST";
    //@"multipart/mixed; boundary=%@"
    NSDictionary *headers = @{@"Content-Type": @"application/json;charset=UTF-8",
                              @"Accept": @"application/json;charset=UTF-8"};
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: urlString]
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval: 30];
    [request setHTTPMethod: httpMethod];
    [request setAllHTTPHeaderFields: headers];
    [request setHTTPBody: bodyData];
    [request setHTTPShouldHandleCookies: NO];
    
    return request;
}

+ (NSMutableURLRequest*) URLRequestWithBodyString: (NSString*)bodyString
{
    NSData *bodyData = bodyString ? [bodyString dataUsingEncoding: NSUTF8StringEncoding] : nil;
    
    return [self URLRequestWithBodyData: bodyData];
}

@end
