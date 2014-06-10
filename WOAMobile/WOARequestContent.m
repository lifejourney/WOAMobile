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

+ (WOARequestContent*) contentForLogin: (NSString*)accountID password: (NSString*)password
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_Login];
    
    content.bodyDictionary = [WOAPacketHelper packetForLogin: accountID password: password];
    
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
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_InitiateWorkflow];
    
    content.bodyDictionary = [WOAPacketHelper packetForInitiateWorkflow: workID];
    
    return content;
}

@end



