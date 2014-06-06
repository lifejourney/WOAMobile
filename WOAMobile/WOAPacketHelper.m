//
//  WOAPacketHelper.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPacketHelper.h"


@implementation WOAPacketHelper

+ (NSString*) msgTypeByFlowActionType: (WOAFLowActionType)flowActionType
{
    NSString *msgType;
    
    switch (flowActionType)
    {
        case WOAFLowActionType_Login:
            msgType = @"login";
            break;
            
        case WOAFLowActionType_GetWorkflowTypeList:
            msgType = @"getTableList";
            break;
            
        default:
            msgType = @"";
            break;
    }
    
    return msgType;
}

+ (NSDictionary*) headerForFlowActionType: (WOAFLowActionType)flowActionType sessionID: (NSString*)sessionID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self msgTypeByFlowActionType: flowActionType] forKey: @"msgType"];
    [dict setValue: sessionID forKey: @"sessionID"];
    
    return dict;
}

+ (NSDictionary*) headerForLogin
{
    return [NSDictionary dictionaryWithObjectsAndKeys: [self msgTypeByFlowActionType: WOAFLowActionType_Login], @"msgType", nil];
}

+ (NSDictionary*) packetDictionaryForLogin: (NSString*)accountID password: (NSString*)password
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForLogin] forKey: @"head"];
    [dict setValue: accountID forKey: @"account"];
    [dict setValue: password forKey: @"psw"];
    [dict setValue: @"12323123" forKey: @"checkSum"];
    [dict setValue: @"1212" forKey: @"phoneID"];
    
    return dict;
}

+ (NSDictionary*) headerFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"head"];
}

+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *header = [self headerFromPacketDictionary: dict];
    
    return [header valueForKeyPath: @"sessionID"];
}

@end
