//
//  WOARootViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WOARootViewController : UITabBarController

- (void) switchToInitiateWorkflow: (BOOL) popToRootVC shouldRefresh: (BOOL)shouldRefresh;
- (void) switchToTodoWorkflow: (BOOL) popToRootVC shouldRefresh: (BOOL)shouldRefresh;

@end
