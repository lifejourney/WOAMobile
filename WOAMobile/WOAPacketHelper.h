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

+ (NSDictionary*) packetDictionaryForLogin: (NSString*)accountID password: (NSString*)password;
+ (NSDictionary*) packetDictionaryForWorkflowTypeList;

+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSArray*) itemsArrayFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) itemNameFromDictionary: (NSDictionary*)dict;
+ (NSArray*) optionArrayFromDictionary: (NSDictionary*)dict;
+ (NSString*) tableIDFromTableDictionary: (NSDictionary*)dict;
+ (NSString*) tableNameFromTableDictionary: (NSDictionary*)dict;

@end
