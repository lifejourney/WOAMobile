//
//  WOARequestContent.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAPacketHelper.h"


@interface WOARequestContent : NSObject

@property (nonatomic, assign) WOAFLowActionType flowActionType;
@property (nonatomic, strong) NSDictionary *bodyDictionary;

+ (WOARequestContent*) requestContentForLogin: (NSString*)accountID password: (NSString*)password;
+ (WOARequestContent*) reqeustContentForWorkflowTypeList;

@end
