//
//  WOACheckForUpdate.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WOACheckForUpdate : NSObject <UIAlertViewDelegate>

+ (void) checkingUpdateFromAppStore: (BOOL)forceUpdate;

@end
