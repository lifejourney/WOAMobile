//
//  WOAPacketHelper.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPacketHelper.h"
#import "WOAAppDelegate.h"


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

+ (NSString*) currentSessionID
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    return appDelegate.sessionID;
}

+ (NSDictionary*) headerForFlowActionType: (WOAFLowActionType)flowActionType
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self msgTypeByFlowActionType: flowActionType] forKey: @"msgType"];
    
    if (flowActionType != WOAFLowActionType_Login)
    {
        [dict setValue: [self currentSessionID] forKey: @"sessionID"];
    }
    
    return dict;
}

+ (NSDictionary*) packetDictionaryForLogin: (NSString*)accountID password: (NSString*)password
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_Login] forKey: @"head"];
    
    [dict setValue: accountID forKey: @"account"];
    [dict setValue: password forKey: @"psw"];
    [dict setValue: @"12323123" forKey: @"checkSum"];
    [dict setValue: @"1212" forKey: @"phoneID"];
    
    return dict;
}

+ (NSDictionary*) packetDictionaryForWorkflowTypeList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetWorkflowTypeList] forKey: @"head"];
    
    return dict;
}

#pragma mark -

+ (NSDictionary*) headerFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"head"];
}

+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *header = [self headerFromPacketDictionary: dict];
    
    return [header valueForKeyPath: @"sessionID"];
}

+ (NSArray*) itemsArrayFromPacketDictionary: (NSDictionary*)dict
{
    id value = [dict valueForKey: @"items"];
    
    return (value && [value isKindOfClass: [NSArray class]]) ? value : nil;
}

+ (NSString*) itemNameFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"name"];
}

+ (NSArray*) optionArrayFromDictionary: (NSDictionary*)dict
{
    id value = [dict valueForKey: @"combo"];
    
    return (value && [value isKindOfClass: [NSArray class]]) ? value : nil;
}

+ (NSString*) tableIDFromTableDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"tableID"];
}

+ (NSString*) tableNameFromTableDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"tableName"];
}

@end
