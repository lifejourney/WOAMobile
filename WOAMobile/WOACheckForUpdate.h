//
//  WOACheckForUpdate.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kSelfAppleID @"908853362"

@interface WOACheckForUpdate : NSObject <UIAlertViewDelegate>

+ (void) checkingUpdateFromAppStore: (void (^)())startHandler endHandler: (void (^)(NSDictionary* appData))endHandler;

@end
