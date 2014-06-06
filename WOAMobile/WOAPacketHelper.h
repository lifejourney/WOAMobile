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

+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict;

@end
