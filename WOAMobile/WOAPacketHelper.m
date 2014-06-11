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
            
        case WOAFLowActionType_GetWorkflowTypeDetail:
            msgType = @"getWorkTable";
            break;
            
        case WOAFLowActionType_InitiateWorkflow:
            msgType = @"sendWorkTable";
            break;
            
        case WOAFLowActionType_SelectedNextStep:
            msgType = @"sendProcessingStyle";
            break;
            
        case WOAFLowActionType_SelectedNextReviewer:
            msgType = @"sendNextStep";
            break;
            
        case WOAFLowActionType_GetTodoWorkflowList:
            msgType = @"getWorkList";
            break;
            
        case WOAFLowActionType_ReviewedWorkflow:
            break;
            
        case WOAFLowActionType_GetHistoryWorkflowList:
            break;
            
        case WOAFLowActionType_GetDraftWorkflowList:
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

+ (NSDictionary*) packetForLogin: (NSString*)accountID password: (NSString*)password
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_Login] forKey: @"head"];
    
    [dict setValue: accountID forKey: @"account"];
    [dict setValue: password forKey: @"psw"];
    [dict setValue: @"12323123" forKey: @"checkSum"];
    [dict setValue: @"1212" forKey: @"phoneID"];
    
    return dict;
}

+ (NSDictionary*) packetForWorkflowTypeList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetWorkflowTypeList] forKey: @"head"];
    
    return dict;
}

+ (NSDictionary*) packetForWorkflowTypeDetail: (NSString*)tableID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetWorkflowTypeDetail] forKey: @"head"];
    [dict setValue: tableID forKey: @"tableID"];
    
    return dict;
}

+ (NSDictionary*) packetForInitiateWorkflow: (NSString*)workID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_InitiateWorkflow] forKey: @"head"];
    
    return dict;
}

#pragma mark -

+ (NSDictionary*) headerFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"head"];
}

+ (NSDictionary*) resultFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"result"];
}

+ (NSString*) resultCodeFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    return [resultDict valueForKey: @"code"];
}

+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"workID"];
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

+ (NSString*) itemTypeFromDictionary: (NSDictionary *)dict
{
    return [dict valueForKey: @"type"];
}

+ (NSString*) itemValueFromDictionary: (NSDictionary *)dict
{
    //TO-DO
    return [dict valueForKey: @"value"];
}

+ (BOOL) itemWritableFromDictionary: (NSDictionary *)dict
{
    NSString *value = [dict valueForKey: @"isWrite"];
    
    return value ? [value boolValue] : NO;
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
    //TO-DO: should using only one: adjust the protocol
    //return [dict valueForKey: @"tableName"];
    
    NSString *name = [dict valueForKey: @"tableName"];
    if (!name) name = [dict valueForKey: @"name"];
    return name;
}

+ (NSDictionary*) tableStructFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"tableStruct"];
}

+ (NSString*) tableIDFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *tableStruct = [self tableStructFromPacketDictionary: dict];
    
    return [self tableIDFromTableDictionary: tableStruct];
}

+ (NSString*) tableNameFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *tableStruct = [self tableStructFromPacketDictionary: dict];

    return [self tableNameFromTableDictionary: tableStruct];
}

@end







