//
//  WOARequestContent.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOARequestContent.h"
#import "WOASession.h"


@implementation WOARequestContent

- (instancetype) initWithFlowActionType: (WOAFLowActionType)flowActionType
{
    if (self = [self init])
    {
        self.flowActionType = flowActionType;
    }
    
    return self;
}


+ (WOARequestContent*) requestContentForLogin: (WOASession*)flowSession
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_Login];
    
    NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc] init];
    
    //TO-DO
    
    content.bodyDictionary = bodyDictionary;
    
    return content;
}

@end
