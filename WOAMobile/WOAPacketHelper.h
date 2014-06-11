//
//  WOAPacketHelper.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAFlowDefine.h"


@interface WOAPacketHelper : NSObject

+ (NSDictionary*) packetForLogin: (NSString*)accountID password: (NSString*)password;
+ (NSDictionary*) packetForWorkflowTypeList;
+ (NSDictionary*) packetForWorkflowTypeDetail: (NSString*)tableID;
+ (NSDictionary*) packetForInitiateWorkflow: (NSString*)workID;


+ (NSDictionary*) resultFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) resultCodeFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict;
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


@end
