//
//  WOARequestContent.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOARequestContent.h"


@implementation WOARequestContent

- (instancetype) initWithFlowActionType: (WOAFLowActionType)flowActionType
{
    if (self = [self init])
    {
        self.flowActionType = flowActionType;
    }
    
    return self;
}

+ (WOARequestContent*) contentForLogin: (NSString*)accountID
                              password: (NSString*)password
                           deviceToken: (NSString*)deviceToken
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_Login];
    
    content.bodyDictionary = [WOAPacketHelper packetForLogin: accountID password: password deviceToken: deviceToken];
    
    return content;
}

+ (WOARequestContent*) contentForWorkflowTypeList
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_GetWorkflowTypeList];
    
    content.bodyDictionary = [WOAPacketHelper packetForWorkflowTypeList];
    
    return content;
}

+ (WOARequestContent*) contentForWorkflowTypeDetail: (NSString*)tableID
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_GetWorkflowTypeDetail];
    
    content.bodyDictionary = [WOAPacketHelper packetForWorkflowTypeDetail: tableID];
    
    return content;
}

+ (WOARequestContent*) contentForInitiateWorkflow: (NSString*)workID
                                          tableID: (NSString*)tableID
                                        tableName: (NSString*)tableName
                                       itemsArray: (NSArray*)itemsArray;
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_InitiateWorkflow];
    
    content.bodyDictionary = [WOAPacketHelper packetForInitiateWorkflow: workID
                                                                tableID: tableID
                                                              tableName: tableName
                                                             itemsArray: itemsArray];
    
    return content;
}

+ (WOARequestContent*) contentForSelectNextStep: (NSString*)workID
                                      processID: (NSString*)processID
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_SelectNextStep];
    
    content.bodyDictionary = [WOAPacketHelper packetForSelectNextStep: workID
                                                            processID: processID];
    
    return content;
    
}

+ (WOARequestContent*) contentForSelectNextReviewer: (NSString*)workID
                                       accountArray: (NSArray*)accountArray
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_SelectNextReviewer];
    
    content.bodyDictionary = [WOAPacketHelper packetForSelectNextReviewer: workID
                                                             accountArray: accountArray];
    
    return content;
    
}

+ (WOARequestContent*) contentForTodoWorkflowList
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_GetTodoWorkflowList];
    
    content.bodyDictionary = [WOAPacketHelper packetForTodoWorkflowList];
    
    return content;
}

+ (WOARequestContent*) contentForWorkflowFormDetail: (NSString*)workID
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_GetWorkflowFormDetail];
    
    content.bodyDictionary = [WOAPacketHelper packetForWorkflowFormDetail: workID];
    
    return content;
}

+ (WOARequestContent*) contentForReviewWorkflow: (NSString*)workID
                                     itemsArray: (NSArray*)itemsArray
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_ReviewWorkflow];
    
    content.bodyDictionary = [WOAPacketHelper packetForReviewWorkflow: workID
                                                           itemsArray: itemsArray];
    
    return content;
}

+ (WOARequestContent*) contentForHistoryWorkflowList
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_GetHistoryWorkflowList];
    
    content.bodyDictionary = [WOAPacketHelper packetForHistoryWorkflowList];
    
    return content;
}

+ (WOARequestContent*) contentForWorkflowViewDetail: (NSString*)workID
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_GetWorkflowViewDetail];
    
    content.bodyDictionary = [WOAPacketHelper packetForWorkflowViewDetail: workID];
    
    return content;
}

+ (WOARequestContent*) contentForDraftWorkflowList
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_GetDraftWorkflowList];
    
    content.bodyDictionary = [WOAPacketHelper packetForDraftWorkflowList];
    
    return content;
}

@end



