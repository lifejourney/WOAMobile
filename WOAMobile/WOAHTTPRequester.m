//
//  WOAHTTPRequester.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAHTTPRequester.h"
#import "NSMutableData+AppendString.h"


@implementation WOAHTTPRequester

+ (NSMutableURLRequest*) URLRequestWithBodyData: (NSData*)bodyData
{
    NSString *urlString = @"http://220.162.12.167:8080/?action=app";
    NSString *httpMethod = @"POST";
    //@"multipart/mixed; boundary=%@"
    NSDictionary *headers = @{@"Content-Type": @"application/x-www-form-urlencoded",
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

+ (NSMutableURLRequest*) URLRequestWithFilePath: (NSString*)filePath
{
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    NSString *urlString = @"http://220.162.12.167:8080/?action=appfile";
    NSString *httpMethod = @"POST";
    NSString *boundary = @"WOABoundary_2014";
    NSDictionary *headers = @{@"Content-Type": [NSString stringWithFormat: @"multipart/form-data; boundary=%@", boundary],
                              @"Accept": @"application/json;charset=UTF-8"};
    
    NSString *boundaryWithPrefix = [NSString stringWithFormat: @"--%@\r\n", boundary];
    NSString *endBoundary = [NSString stringWithFormat: @"--%@--\r\n", boundary];
    
    NSString *fileName = [filePath lastPathComponent];
    NSString *contentDis;
    
//sessionID: "979"
//workID: "47"
//tableID: "3"
//itemID: 空或0时表示新建的工作事务，非空时表示待办的事务步骤id
//fieldname:"附件"
//fieldtype:"attfile"
//att_title:"附件标题...."
//att_file: "......\test.jpg"
    [bodyData appendString: boundaryWithPrefix];
    contentDis = [NSString stringWithFormat: @"Content-disposition: form-data; name=\"fieldname\"\r\n\r\n"];
    [bodyData appendString: contentDis];
    [bodyData appendString: @"附件"];
    [bodyData appendString: @"\r\n"];
    
    [bodyData appendString: boundaryWithPrefix];
    contentDis = [NSString stringWithFormat: @"Content-disposition: form-data; name=\"att_file\"; filename=\"%@\"\r\n", fileName];
    [bodyData appendString: contentDis];
    //TO-DO:
    [bodyData appendString: @"Content-Type: image/png\r\n\r\n"];
    [bodyData appendDataFromFile: filePath];
    [bodyData appendString: @"\r\n"];
    
    [bodyData appendString: endBoundary];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: urlString]
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval: 30];
    [request setHTTPMethod: httpMethod];
    [request setAllHTTPHeaderFields: headers];
    [request setValue: [NSString stringWithFormat: @"%d", [bodyData length]] forHTTPHeaderField: @"Content-Length"];
    [request setHTTPBody: bodyData];
    [request setHTTPShouldHandleCookies: NO];
    
    return request;
}

@end
