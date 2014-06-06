//
//  WOAFlowDefine.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, WOAFLowActionType)
{
    WOAFLowActionType_None,
    WOAFLowActionType_Login,
    WOAFLowActionType_GetWorkflowTypeList,
    WOAFLowActionType_InitiateWorkflow,
    WOAFLowActionType_SelectedNextStep,
    WOAFLowActionType_SelectedNextReviewer,
    WOAFLowActionType_GetTodoWorkflowList,
    WOAFLowActionType_ReviewedWorkflow,
    WOAFLowActionType_GetHistoryWorkflowList,
    WOAFLowActionType_GetDraftWorkflowList
};

typedef NS_ENUM(NSUInteger, WOAHTTPRequestResult)
{
    WOAHTTPRequestResult_Unknown,
    WOAHTTPRequestResult_Success,
    WOAHTTPRequestResult_NotFound,
    WOAHTTPRequestResult_Unauthorized,
    WOAHTTPRequestResult_SessionInvalid,
    WOAHTTPRequestResult_NetError,
    WOAHTTPRequestResult_RequestError,
    WOAHTTPRequestResult_ServerError,
    WOAHTTPRequestResult_SaveFileError,
    WOAHTTPRequestResult_JSONSerializationError,
    WOAHTTPRequestResult_JSONParseError,
    WOAHTTPRequestResult_Cancelled
};

