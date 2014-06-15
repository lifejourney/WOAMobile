//
//  WOAWorkflowFormListViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOAFlowDefine.h"
#import "WOAStartWorkflowActionReqeust.h"


@interface WOAWorkflowFormListViewController : UIViewController <WOAStartWorkflowActionReqeust>

@property (nonatomic, assign) WOAFLowActionType listActionType;

@end
