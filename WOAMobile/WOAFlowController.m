//
//  WOAFlowController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAFlowController.h"
#import "NSFileManager+AppFolder.h"
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

- (void) sendUploadAttachmentWithContent: (WOARequestContent*)requestContent
{
    self.httpResponse = nil;
    self.connectionError = nil;
    self.receivedData = [[NSMutableData alloc] init];
    
    NSString *filePath = [WOAPacketHelper filePathFromDictionary: requestContent.bodyDictionary];
    
    if (filePath)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath: filePath])
        {
            self.currentActionType = requestContent.flowActionType;
            
            NSMutableURLRequest *request = [WOAHTTPRequester URLRequestForUploadAttachment: requestContent.bodyDictionary];
            
            NSLog(@"To send request for upload attachment.\nFile: %@\n-------->\n\n", filePath);
            
            self.httpConnection = [[NSURLConnection alloc] initWithRequest: request
                                                                  delegate: self
                                                          startImmediately: YES];
        }
        else
        {
            self.responseContent.requestResult = WOAHTTPRequestResult_InvalidAttachmentFile;
            self.responseContent.resultDescription = @"无效的上传: 附件不存在.";
            
            NSLog(@"Request fail during JSON serialization. filePath: %@", filePath);
            
            self.httpConnection = nil;
        }
    }
    else
    {
        self.responseContent.requestResult = WOAHTTPRequestResult_InvalidAttachmentFile;
        self.responseContent.resultDescription = @"无效的上传: 附件名称.";
        
        NSLog(@"Request fail during upload attachment.");
        
        self.httpConnection = nil;
    }
}

- (void) sendRequestWithContent: (WOARequestContent*)requestContent
{
    if (requestContent.flowActionType == WOAFLowActionType_UploadAttachment)
    {
        [self sendUploadAttachmentWithContent: requestContent];
        
        return;
    }
    
    NSError *error;
    self.httpResponse = nil;
    self.connectionError = nil;
    self.receivedData = [[NSMutableData alloc] init];
    
    if (requestContent.bodyDictionary)
    {
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject: requestContent.bodyDictionary
                                                           options: 0
                                                             error: &error];
        
        if (bodyData)
        {
            self.currentActionType = requestContent.flowActionType;
            
            NSMutableURLRequest *request = [WOAHTTPRequester URLRequestWithBodyData: bodyData];
            
            NSLog(@"To send request for action: %lu\n%@\n-------->\n\n",
                    requestContent.flowActionType,
                    [self formattedString: [[NSString alloc] initWithData: bodyData encoding: NSUTF8StringEncoding]]);//requestContent.bodyDictionary);
            
            self.httpConnection = [[NSURLConnection alloc] initWithRequest: request
                                                                  delegate: self
                                                          startImmediately: YES];
        }
        else
        {
            self.responseContent.requestResult = WOAHTTPRequestResult_JSONSerializationError;
            self.responseContent.resultDescription = @"无效的请求内容.";
            
            NSLog(@"Request fail during JSON serialization. error: %@\n request body: %@", [error localizedDescription], requestContent.bodyDictionary);
            
            self.httpConnection = nil;
        }
    }
    else
    {
        self.responseContent.requestResult = WOAHTTPRequestResult_JSONSerializationError;
        self.responseContent.resultDescription = @"无效的请求.";
        
        NSLog(@"Request fail during JSON serialization.");
        
        self.httpConnection = nil;
    }
}

- (void) actionForCommonError
{
    if (!self.responseContent || self.isCancelled)
        return;
    
    
    if (self.responseContent.requestResult != WOAHTTPRequestResult_Success)
    {
        if (self.responseContent.requestResult == WOAHTTPRequestResult_InvalidSession)
        {
            WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate presentLoginViewController: NO animated: NO];
        }
        
        NSString *msgContent = self.responseContent.resultDescription;
        
        if (msgContent && ([msgContent length] > 0))
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil
                                                                message: msgContent
                                                               delegate: nil
                                                      cancelButtonTitle: @"确定"
                                                      otherButtonTitles: nil, nil];
            
            [alertView show];
        }
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
        
        [self sendRequestWithContent: self.requestContent];
        
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
            dispatch_async(dispatch_get_main_queue(), ^
            {
                self.completionHandler(self.responseContent);
                
                [self actionForCommonError];
            });
        }
        else
        {
            self.completionHandler(self.responseContent);
            
            [self performSelectorOnMainThread: @selector(actionForCommonError) withObject: nil waitUntilDone: YES];
        }
    }
    else
    {
        [self performSelectorOnMainThread: @selector(actionForCommonError) withObject: nil waitUntilDone: YES];
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

- (NSString*) formattedString: (NSString*)str
{
    NSString *logString = [str stringByReplacingOccurrencesOfString: @"," withString: @",\n"];
    logString = [logString stringByReplacingOccurrencesOfString: @"]," withString: @"],\n"];
    logString = [logString stringByReplacingOccurrencesOfString: @"}," withString: @"},\n"];
    logString = [logString stringByReplacingOccurrencesOfString: @":[" withString: @":[\n"];
    logString = [logString stringByReplacingOccurrencesOfString: @":{" withString: @":{\n"];
    
    return logString;
}
- (void) connectionDidFinishLoading: (NSURLConnection *)connection
{
    NSError *error;
    NSDictionary *bodyDictionary = nil;
    WOAHTTPRequestResult requestResult;
    NSString *resultDescription = nil;
    
    if (self.httpResponse)
    {
        requestResult = [self httpRequestResultFromHTTPStatus: self.httpResponse.statusCode];
        
        if (requestResult == WOAHTTPRequestResult_Success)
        {
            //TO-DO:
            NSString *tmpString = [[NSString alloc] initWithData: self.receivedData encoding: NSUTF8StringEncoding];
            tmpString = [tmpString stringByReplacingOccurrencesOfString: @"\000" withString: @""];
            
            bodyDictionary = [NSJSONSerialization JSONObjectWithData: self.receivedData
                                                                 options: 0
                                                               error: &error];
            
            if (bodyDictionary)
            {
                NSLog(@"Received response for action: %lu\n%@\n<--------\n\n",
                        self.currentActionType,
                        [self formattedString: tmpString]);//bodyDictionary);
                
                WOAWorkflowResultCode resultCode = [WOAPacketHelper resultCodeFromPacketDictionary: bodyDictionary];
                
                if (resultCode != WOAWorkflowResultCode_Success)
                {
                    resultDescription = [WOAPacketHelper resultDescriptionFromPacketDictionary: bodyDictionary];
                    
                    //TO-DO, temporarily
//                    if (resultCode == WOAWorkflowResultCode_InvalidSession)
//                        requestResult = WOAHTTPRequestResult_InvalidSession;
//                    else
//                        requestResult = WOAHTTPRequestResult_ErrorWithDescription;
                    
                    NSString *testString = [resultDescription stringByReplacingOccurrencesOfString: @"用户未登录" withString: @""];
                    if ([testString isEqualToString: resultDescription])
                        requestResult = WOAHTTPRequestResult_ErrorWithDescription;
                    else
                        requestResult = WOAHTTPRequestResult_InvalidSession;
                    
                    if (!resultDescription || ([resultDescription length] <= 0))
                    {
                        resultDescription = [NSString stringWithFormat: @"code: %lu", resultCode];
                    }
                }
            }
            else
            {
                requestResult = WOAHTTPRequestResult_JSONParseError;
                resultDescription = [NSString stringWithFormat: @"[%@, %d]\n无效的响应内容[%d]:\n %@",
                                     [NSDate date],
                                     self.httpResponse.statusCode,
                                     [tmpString length],
                                     [tmpString substringToIndex: 30]];
                
                NSLog(@"Request fail during JSON parsing. error: %@\n respone body: %@", [error localizedDescription], tmpString);
            }
        }
    }
    else
    {
        requestResult = WOAHTTPRequestResult_NetError;
        resultDescription = @"无响应内容";
    }
    
    self.responseContent.HTTPStatus = self.httpResponse.statusCode;
    self.responseContent.requestResult = requestResult;
    self.responseContent.resultDescription = resultDescription;
    self.responseContent.bodyDictionary = bodyDictionary;
    
    if (requestResult == WOAHTTPRequestResult_Success)
    {
        if (self.currentActionType == WOAFLowActionType_Login)
        {
            WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            appDelegate.sessionID = [WOAPacketHelper sessionIDFromPacketDictionary: bodyDictionary];
            
            appDelegate.latestLoginRequestContent = self.requestContent;
        }
        
        if (self.currentActionType == self.responseContent.flowActionType)
        {
            self.responseContent.bodyDictionary = bodyDictionary;
            
            self.httpConnection = nil;
        }
        else
        {
            //Resend the request
            [self sendRequestWithContent: self.requestContent];
        }
    }
    else if (requestResult == WOAHTTPRequestResult_InvalidSession)
    {
        WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.sessionID = nil;
        
        if (self.currentActionType == self.responseContent.flowActionType)
        {
            if (self.responseContent.flowActionType == WOAFLowActionType_Login)
            {
                NSLog(@"Request fail for invalid session (login). error: %@\n respone body: %@", [error localizedDescription], bodyDictionary);
                
                self.httpConnection = nil;
            }
            else
            {
                if (self.hasRefreshSession)
                {
                    //Auto relogined
                    NSLog(@"Request fail for invalid session (request retried). error: %@\n respone body: %@", [error localizedDescription], bodyDictionary);
                    
                    self.httpConnection = nil;
                }
                else
                {
                    self.hasRefreshSession = YES;
                    
                    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    
                    [self sendRequestWithContent: appDelegate.latestLoginRequestContent];
                }
            }
        }
        else
        {
            NSLog(@"currentAction: %lu, origin action: %lu", self.currentActionType, self.responseContent.flowActionType);
            NSLog(@"Request fail for invalid session (login when retrying). error: %@\n respone body: %@", [error localizedDescription], bodyDictionary);
            
            self.httpConnection = nil;
        }
    }
    else
    {
        self.httpConnection = nil;
        
        NSString *respString = [[NSString alloc] initWithData: self.receivedData encoding: NSUTF8StringEncoding];
        NSLog(@"fail resp: \n%@", respString);
    }
}

- (void) connection: (NSURLConnection *)connection didFailWithError: (NSError *)error
{
    NSLog(@"Connection error[%ld] reason: %@. \n response: %@", (long)[error code], [error localizedFailureReason], self.httpResponse);
    self.connectionError = error;
    
    self.responseContent.requestResult = WOAHTTPRequestResult_NetError;
    self.responseContent.resultDescription = [NSString stringWithFormat: @"网络连接失败: %ld", (long)[error code]];
    
    self.httpConnection = nil;
}

@end









