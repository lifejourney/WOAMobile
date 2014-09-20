//
//  WOAPacketHelper.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPacketHelper.h"
#import "WOAAppDelegate.h"
#import "CommonCrypto/CommonDigest.h"


@implementation WOAPacketHelper

+ (NSString*) msgTypeByFlowActionType: (WOAFLowActionType)flowActionType
{
    NSString *msgType;
    
    switch (flowActionType)
    {
        case WOAFLowActionType_Login:
            msgType = kWOAValue_MsgType_Login;
            break;
            
        case WOAFLowActionType_Logout:
            msgType = @"logout";
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
            
        case WOAFLowActionType_UploadAttachment:
            msgType = @"";
            
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

+ (NSString*) checkSumForLogin: (NSString*)account password: (NSString*)password
{
    NSString *mixed = [NSString stringWithFormat: @"%@%@%@", kWOAValue_MsgType_Login, account, password];
    
    const char *cStr = [mixed UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *md5 = [NSString stringWithFormat:
                     @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                    result[0], result[1], result[2], result[3],
                    result[4], result[5], result[6], result[7],
                    result[8], result[9], result[10], result[11],
                    result[12], result[13], result[14], result[15]
                    ];
    
    NSRange range = NSMakeRange(8, 24);
    return [md5 substringWithRange: range];
}

+ (NSDictionary*) packetForLogin: (NSString*)accountID
                        password: (NSString*)password
                     deviceToken: (NSString*)deviceToken
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_Login] forKey: @"head"];
    
    [dict setValue: accountID forKey: @"account"];
    [dict setValue: password forKey: @"psw"];
    [dict setValue: [self checkSumForLogin: accountID password: password] forKey: @"checkSum"];
    [dict setValue: deviceToken forKey: @"deviceToken"];
    
    return dict;
}

+ (NSDictionary*) packetForLogout
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_Logout] forKey: @"head"];
    
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
                                 value: (id)value
                            typeString: (NSString*)typeString
                               section: (NSNumber*)sectionNum
                                   row: (NSNumber*)rowNum
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: key forKey: @"name"];
    [dict setValue: value forKey: @"value"];
    [dict setValue: typeString forKey: @"type"];
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

+ (NSDictionary*) packetForUploadAttachment: (NSString*)workID
                                    tableID: (NSString*)tableID
                                     itemID: (NSString*)itemID
                                   filePath: (NSString*)filePath
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_UploadAttachment] forKey: @"head"];
    [dict setValue: workID forKey: @"workID"];
    [dict setValue: tableID forKey: @"tableID"];
    [dict setValue: itemID forKey: @"itemID"];
    [dict setValue: filePath forKey: @"filePath"];
    
    return dict;
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

+ (NSDictionary*) packetForWorkflowFormDetail: (NSString*)itemID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetWorkflowFormDetail] forKey: @"head"];
    [dict setValue: itemID forKey: @"itemID"];
    
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

+ (NSDictionary*) packetForWorkflowViewDetail: (NSString*)itemID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: [self headerForFlowActionType: WOAFLowActionType_GetWorkflowViewDetail] forKey: @"head"];
    [dict setValue: itemID forKey: @"itemID"];
    
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

+ (NSString*) resultDescriptionFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    return [resultDict valueForKey: @"description"];
}

+ (NSString*) descriptionFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"description"];
}

+ (NSString*) resultUploadedFileNameFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    return [resultDict valueForKey: @"ret_file"];
}

+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"workID"];
}

+ (NSString*) itemIDFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"itemID"];
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

+ (NSString*) abstractFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"abstract"];
}

+ (NSString*) createTimeFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"createTime"];
}

+ (NSString*) filePathFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"filePath"];
}

+ (NSString*) attachmentTitleFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"title"];
}

+ (NSString*) attachmentURLFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"url"];
}

@end







