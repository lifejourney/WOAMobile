//
//  WOAPropertyInfo.h
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAAccountCredential.h"


@interface WOAPropertyInfo : NSObject

+ (WOAAccountCredential*) latestLoginedAccount;
+ (void) saveLatestLoginAccount: (WOAAccountCredential*)account;
+ (void) saveLatestLoginAccountID: (NSString*)accountID password: (NSString*)password;

@end
