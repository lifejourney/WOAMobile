//
//  WOAPacketHelper.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAFlowDefine.h"


#define kWOAKey_PinyinInitial @"_pinyin"
#define kWOAItemIndexPath_SectionKey @"_section"
#define kWOAItemIndexPath_RowKey @"_row"
#define kWOAKey_ProcessID @"processID"
#define kWOAKey_CreateTime @"createTime"
#define kWOAValue_MsgType_Login @"login"

@interface WOAPacketHelper : NSObject

+ (NSDictionary*) packetForLogin: (NSString*)accountID
                        password: (NSString*)password
                     deviceToken: (NSString*)deviceToken;
+ (NSDictionary*) packetForLogout;
+ (NSDictionary*) packetForWorkflowTypeList;
+ (NSDictionary*) packetForWorkflowTypeDetail: (NSString*)tableID;
+ (NSDictionary*) packetForItemWithKey: (NSString*)key
                                 value: (id)value
                            typeString: (NSString*)typeString
                               section: (NSNumber*)sectionNum
                                   row: (NSNumber*)rowNum;
+ (NSDictionary*) itemWithoutIndexPathFromDictionary: (NSDictionary*)fromDict;
+ (NSDictionary*) packetForTableStruct: (NSString*)tableID
                             tableName: (NSString*)tableName;
+ (NSDictionary*) packetForUploadAttachment: (NSString*)workID
                                    tableID: (NSString*)tableID
                                     itemID: (NSString*)itemID
                                   filePath: (NSString*)filePath
                                      title: (NSString*)title;
+ (NSDictionary*) packetForInitiateWorkflow: (NSString*)workID
                                    tableID: (NSString*)tableID
                                  tableName: (NSString*)tableName
                                 itemsArray: (NSArray*)itemsArray;
+ (NSDictionary*) packetForSelectNextStep: (NSString*)workID
                                processID: (NSString*)processID;
+ (NSDictionary*) packetForSelectNextReviewer: (NSString*)workID
                                 accountArray: (NSArray*)accountArray;
+ (NSDictionary*) packetForTodoWorkflowList;
+ (NSDictionary*) packetForWorkflowFormDetail: (NSString*)itemID;
+ (NSDictionary*) packetForReviewWorkflow: (NSString*)workID
                               itemsArray: (NSArray*)itemsArray;
+ (NSDictionary*) packetForHistoryWorkflowList;
+ (NSDictionary*) packetForWorkflowViewDetail: (NSString*)itemID;
+ (NSDictionary*) packetForDraftWorkflowList;

+ (NSDictionary*) resultFromPacketDictionary: (NSDictionary*)dict;
+ (WOAWorkflowResultCode) resultCodeFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) resultDescriptionFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) descriptionFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) resultUploadedFileNameFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) itemIDFromDictionary: (NSDictionary*)dict;
+ (NSArray*) itemsArrayFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) itemNameFromDictionary: (NSDictionary*)dict;
+ (NSString*) itemTypeFromDictionary: (NSDictionary *)dict;
+ (NSString*) itemValueFromDictionary: (NSDictionary *)dict;
+ (BOOL) itemWritableFromDictionary: (NSDictionary *)dict;
+ (NSArray*) optionArrayFromDictionary: (NSDictionary*)dict;
+ (NSString*) tableIDFromTableDictionary: (NSDictionary*)dict;
+ (NSString*) tableNameFromTableDictionary: (NSDictionary*)dict;
+ (NSDictionary*) tableStructFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) tableIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) tableNameFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) processIDFromDictionary: (NSDictionary*)dict;
+ (NSString*) processNameFromDictionary: (NSDictionary*)dict;
+ (NSArray*) processNameArrayFromProcessArray: (NSArray*)arr;
+ (NSString*) accountIDFromDictionary: (NSDictionary*)dict;
+ (NSString*) accountNameFromDictionary: (NSDictionary*)dict;
+ (NSString*) formTitleFromDictionary: (NSDictionary*)dict;
+ (NSString*) abstractFromDictionary: (NSDictionary*)dict;
+ (NSString*) createTimeFromDictionary: (NSDictionary*)dict;

+ (NSString*) filePathFromDictionary: (NSDictionary*)dict;
+ (NSString*) attTitleFromDictionary: (NSDictionary*)dict;

+ (NSString*) attachmentTitleFromDictionary: (NSDictionary*)dict;
+ (NSString*) attachmentURLFromDictionary: (NSDictionary*)dict;

@end
