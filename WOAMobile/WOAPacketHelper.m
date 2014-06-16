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
            
        case WOAFLowActionType_SelectNextStep:
            msgType = @"sendProcessingStyle";
            break;
            
        case WOAFLowActionType_SelectNextReviewer:
            msgType = @"sendNextStep";
            break;
            
        case WOAFLowActionType_GetTodoWorkflowList:
            msgType = @"getWorkList";
            break;
            
        case WOAFLowActionType_GetWorkflowFormDetail:
            msgType = @"getTableDetail";
            break;
            
        case WOAFLowActionType_ReviewWorkflow:
            msgType = @"sendProcessing";
            break;
            
        case WOAFLowActionType_GetHistoryWorkflowList:
            msgType = @"getQueryList";
            break;
            
        case WOAFLowActionType_GetWorkflowViewDetail:
            msgType = @"getViewTable";
            break;
            
        case WOAFLowActionType_GetDraftWorkflowList:
            msgType = @""; //TO-DO
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

+ (NSDictionary*) packetForLogin: (NSString*)accountID
                        password: (NSString*)password
                     deviceToken: (NSString*)deviceToken
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_Login] forKey: @"head"];
    
    [dict setValue: accountID forKey: @"account"];
    [dict setValue: password forKey: @"psw"];
    //TO-DO
    //[dict setValue:  forKey: @"checkSum"];
    [dict setValue: deviceToken forKey: @"deviceToken"];
    
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

+ (NSDictionary*) packetForItemWithKey: (NSString*)key
                                 value: (NSString*)value
                               section: (NSNumber*)sectionNum
                                   row: (NSNumber*)rowNum
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: key forKey: @"name"];
    [dict setValue: value forKey: @"value"];
    [dict setValue: sectionNum forKey: kWOAItemIndexPath_SectionKey];
    [dict setValue: rowNum forKey: kWOAItemIndexPath_RowKey];
    
    return dict;
}

+ (NSDictionary*) itemWithoutIndexPathFromDictionary: (NSDictionary*)fromDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: fromDict];
    
    [dict setValue:nil forKey: kWOAItemIndexPath_SectionKey];
    [dict setValue:nil forKey: kWOAItemIndexPath_RowKey];
    
    return dict;
}

+ (NSDictionary*) packetForTableStruct: (NSString*)tableID
                             tableName: (NSString*)tableName
{
    //TO-DO: name --> tableName
    return [NSDictionary dictionaryWithObjectsAndKeys: tableID, @"tableID", tableName, @"name", nil];
}

+ (NSDictionary*) packetForInitiateWorkflow: (NSString*)workID
                                    tableID: (NSString*)tableID
                                  tableName: (NSString*)tableName
                                 itemsArray: (NSArray*)itemsArray
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_InitiateWorkflow] forKey: @"head"];
    [dict setValue: workID forKey: @"workID"];
    [dict setValue: [self packetForTableStruct: tableID tableName: tableName] forKey: @"tableStruct"];
    [dict setValue: itemsArray forKey: @"items"];
    
    return dict;
}

+ (NSDictionary*) packetForSelectNextStep: (NSString*)workID
                                processID: (NSString*)processID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_SelectNextStep] forKey: @"head"];
    [dict setValue: workID forKey: @"workID"];
    [dict setValue: processID forKey: kWOAKey_ProcessID];
    
    return dict;
    
}

+ (NSDictionary*) packetForSelectNextReviewer: (NSString*)workID
                                 accountArray: (NSArray*)accountArray
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_SelectNextReviewer] forKey: @"head"];
    [dict setValue: workID forKey: @"workID"];
    [dict setValue: accountArray forKey: @"account"];
    
    return dict;
}

+ (NSDictionary*) packetForTodoWorkflowList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetTodoWorkflowList] forKey: @"head"];
    
    return dict;
}

+ (NSDictionary*) packetForWorkflowFormDetail: (NSString*)workID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetWorkflowFormDetail] forKey: @"head"];
    [dict setValue: workID forKey: @"workID"];
    
    return dict;
}

+ (NSDictionary*) packetForReviewWorkflow: (NSString*)workID
                               itemsArray: (NSArray*)itemsArray
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_ReviewWorkflow] forKey: @"head"];
    [dict setValue: workID forKey: @"workID"];
    [dict setValue: itemsArray forKey: @"items"];
    
    return dict;
}

+ (NSDictionary*) packetForHistoryWorkflowList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetHistoryWorkflowList] forKey: @"head"];
    
    return dict;
}

+ (NSDictionary*) packetForWorkflowViewDetail: (NSString*)workID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetWorkflowViewDetail] forKey: @"head"];
    [dict setValue: workID forKey: @"workID"];
    
    return dict;
}

+ (NSDictionary*) packetForDraftWorkflowList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
 
    //TO-DO
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetDraftWorkflowList] forKey: @"head"];
    
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

+ (WOAWorkflowResultCode) resultCodeFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    NSString *codeString = [resultDict valueForKey: @"code"];
    
    WOAWorkflowResultCode resultCode = codeString ? [codeString integerValue] : WOAWorkflowResultCode_Unknown;
    
    if (resultCode == WOAWorkflowResultCode_Success)
    {
        if (![codeString isEqualToString: @"0"])
            resultCode = WOAWorkflowResultCode_Unknown;
    }
    
    return resultCode;
}

+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"workID"];
}

+ (NSString*) workIDFromDictionary: (NSDictionary*)dict
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
    //TO-DO
    id value = [dict valueForKey: @"items"];
    if (!value) value = [dict valueForKey: @"itmes"];
    
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

+ (NSString*) processIDFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOAKey_ProcessID];
}

+ (NSString*) processNameFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"tableName"];
}

+ (NSArray*) processNameArrayFromProcessArray: (NSArray*)arr
{
    NSMutableArray *nameArray = [[NSMutableArray alloc] initWithCapacity: [arr count]];
    
    for (NSUInteger i = 0; i < [arr count];  i++)
        [nameArray addObject: [self processNameFromDictionary: [arr objectAtIndex: i]]];
    
    return nameArray;
}

+ (NSString*) accountIDFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"account"];
}

+ (NSString*) accountNameFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"name"];
}

+ (NSString*) formTitleFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"workStyle"];
}

+ (NSString*) createTimeFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"createTime"];
}

@end







