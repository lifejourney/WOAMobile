//
//  WOAResponeContent.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAFlowDefine.h"


@interface WOAResponeContent : NSObject

@property (nonatomic, assign) WOAFLowActionType flowActionType;
@property (nonatomic, strong) NSDictionary *bodyDictionary;

@property (nonatomic, assign) WOAHTTPRequestResult requestResult;
@property (nonatomic, assign) NSInteger HTTPStatus;

@end
