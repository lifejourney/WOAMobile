//
//  WOAPropertyInfo.h
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WOAPropertyInfo : NSObject

+ (NSString*) latestLoginAccountID;
+ (void) saveLatestLoginAccount: (NSString*)accountID;

@end
