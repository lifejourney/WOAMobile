//
//  WOAFlowController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAFlowController.h"
#import "WOAAppDelegate.h"
#import "WOAFlowDefine.h"
#import "WOAHTTPRequester.h"
#import "WOAPacketHelper.h"


@interface WOAFlowController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) WOAResponeContent *responseContent;
@property (nonatomic, strong) WOARequestContent *requestContent;
@property (nonatomic, copy) void (^completionHandler)(WOAResponeContent *responseContent);
@property (nonatomic, assign) BOOL completeOnMainQueue;

@property (nonatomic, assign) WOAFLowActionType currentActionType;
@property (nonatomic, assign) BOOL hasRefreshSession;

@property (nonatomic, strong) NSThread *currentThread;
@property (nonatomic, strong) NSURLConnection *httpConnection;
@property (nonatomic, strong) NSHTTPURLResponse *httpResponse;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSError *connectionError;

@end


@implementation WOAFlowController

- (id) init
{
    if (self = [super init])
    {
        self.currentActionType = WOAFLowActionType_None;
        self.hasRefreshSession = NO;
        
        self.responseContent = [[WOAResponeContent alloc] init];
    }
    
    
    return self;
}


- (instancetype) initWithRequestContent: (WOARequestContent*)requestContent
                    completeOnMainQueue: (BOOL)completeOnMainQueue
                      completionHandler: (void (^)(WOAResponeContent *responseContent))handler;
{
    if (self = [self init])
    {
        self.requestContent = requestContent;
        self.completionHandler = handler;
        self.completeOnMainQueue = completeOnMainQueue;
    }
    
    return self;
}

+ (void) sendAsynRequestWithContent: (WOARequestContent*)requestContent
                              queue: (NSOperationQueue*)queue
                completeOnMainQueue: (BOOL)completeOnMainQueue
                  completionHandler: (void (^)(WOAResponeContent *responseContent))handler;
{
    WOAFlowController *operation = [[WOAFlowController alloc] initWithRequestContent: requestContent
                                                                 completeOnMainQueue: completeOnMainQueue
                                                                   completionHandler: handler];
    [queue addOperation: operation];
}

- (WOAHTTPRequestResult) httpRequestResultFromHTTPStatus: (NSInteger)responseStatus
{
	WOAHTTPRequestResult requestResult;
	
	if (responseStatus >= 200 && responseStatus <= 299)
	{
		requestResult = WOAHTTPRequestResult_Success;
	}
	else if(responseStatus == 401)
	{
		requestResult = WOAHTTPRequestResult_Unauthorized;
	}
	else if(responseStatus == 404)
	{
		requestResult = WOAHTTPRequestResult_NotFound;
	}
	else if (responseStatus >= 300 && responseStatus <= 499)
	{
		requestResult = WOAHTTPRequestResult_RequestError;
	}
	else if(responseStatus == 500)
	{
		requestResult = WOAHTTPRequestResult_ServerError;
	}
	else
	{
		requestResult = WOAHTTPRequestResult_Unknown;
	}
	
	return requestResult;
}

- (void) sendRequestWithType: (WOARequestContent*)requestContent
{
    NSError *error;
    self.httpResponse = nil;
    self.connectionError = nil;
    self.receivedData = [[NSMutableData alloc] init];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject: requestContent.bodyDictionary
                                                       options: 0
                                                         error: &error];
    if (bodyData)
    {
        self.currentActionType = requestContent.flowActionType;
        
        NSMutableURLRequest *request = [WOAHTTPRequester URLRequestWithBodyData: bodyData];
        
        NSLog(@"To send request for action: %d\n%@", requestContent.flowActionType, requestContent.bodyDictionary);
        
        self.httpConnection = [[NSURLConnection alloc] initWithRequest: request
                                                              delegate: self
                                                      startImmediately: YES];
    }
    else
    {
        self.responseContent.requestResult = WOAHTTPRequestResult_JSONSerializationError;
        
        NSLog(@"Request fail during JSON serialization. error: %@\n request body: %@", [error localizedDescription], self.requestContent.bodyDictionary);
        
        self.httpConnection = nil;
    }
}

- (void) main
{
    self.responseContent.flowActionType = self.requestContent.flowActionType;
    self.responseContent.requestResult = WOAHTTPRequestResult_Unknown;
    
    if (!self.isCancelled)
    {
        self.currentThread = [NSThread currentThread];
        self.httpConnection = nil;
        
        [self sendRequestWithType: self.requestContent];
        
        while (self.httpConnection)
        {
            [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate distantFuture]];
        }
        
        self.currentThread = nil;
    }
    else
        self.responseContent.requestResult = WOAHTTPRequestResult_Cancelled;
    
    if (self.completionHandler)
    {
        if (self.completeOnMainQueue)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionHandler(self.responseContent);
            });
        }
        else
            self.completionHandler(self.responseContent);
    }
}

- (NSURLRequest*) connection: (NSURLConnection *)connection
             willSendRequest: (NSURLRequest *)request
            redirectResponse: (NSURLResponse *)response
{
    return request;
}

- (void) connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)response
{
    self.httpResponse = (NSHTTPURLResponse *)response;
}

- (void) connection: (NSURLConnection *)connection didReceiveData: (NSData *)data
{
    [self.receivedData appendData: data];
}

- (void) connectionDidFinishLoading: (NSURLConnection *)connection
{
    NSError *error;
    WOAHTTPRequestResult requestResult;
    
    if (self.httpResponse == nil)
        requestResult = WOAHTTPRequestResult_NetError;
    else
        requestResult = [self httpRequestResultFromHTTPStatus: self.httpResponse.statusCode];
    
    self.responseContent.requestResult = requestResult;
    self.responseContent.HTTPStatus = self.httpResponse.statusCode;
    
    //TO-DO, session is invalid
    
    if (requestResult == WOAHTTPRequestResult_Success)
    {
//        //TO-DO:
//        NSString *tmpString = [[NSString alloc] initWithData: self.receivedData encoding: NSUTF8StringEncoding];
//        tmpString = [tmpString stringByReplacingOccurrencesOfString: @"\000" withString: @""];
//        NSData *tmpData = [tmpString dataUsingEncoding: NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: self.receivedData
                                                             options: 0
                                                               error: &error];
        
        if (dict)
        {
            NSLog(@"Received response for action: %d\n%@", self.currentActionType, dict);
            
            if (self.currentActionType == WOAFLowActionType_Login)
            {
                WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                
                appDelegate.sessionID = [WOAPacketHelper sessionIDFromPacketDictionary: dict];
            }
            
            if (self.currentActionType == self.responseContent.flowActionType)
            {
                self.responseContent.bodyDictionary = dict;
                
                self.httpConnection = nil;
            }
            else
            {
                //Resend the request
                [self sendRequestWithType: self.requestContent];
            }
        }
        else
        {
            self.responseContent.requestResult = WOAHTTPRequestResult_JSONParseError;
            
            NSLog(@"Request fail during JSON parsing. error: %@\n respone body: %@", [error localizedDescription], dict);
            
            self.httpConnection = nil;
        }
    }
    else
    {
        self.httpConnection = nil;
    }
}

- (void) connection: (NSURLConnection *)connection didFailWithError: (NSError *)error
{
    NSLog(@"Connection error[%d] reason: %@. \n response: %@", [error code], [error localizedFailureReason], self.httpResponse);
    self.connectionError = error;
    
    self.responseContent.requestResult = WOAHTTPRequestResult_NetError;
    
    self.httpConnection = nil;
}

@end









