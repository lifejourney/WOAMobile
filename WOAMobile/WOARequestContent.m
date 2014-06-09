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

+ (WOARequestContent*) requestContentForLogin: (NSString*)accountID password: (NSString*)password
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_Login];
    
    content.bodyDictionary = [WOAPacketHelper packetDictionaryForLogin: accountID password: password];
    
    return content;
}

+ (WOARequestContent*) reqeustContentForWorkflowTypeList
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_GetWorkflowTypeList];
    
    content.bodyDictionary = [WOAPacketHelper packetDictionaryForWorkflowTypeList];
    
    return content;
}

@end
