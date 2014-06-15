//
//  WOAWorkflowDetailViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOAFlowDefine.h"


@interface WOAWorkflowDetailViewController : UIViewController

@property (nonatomic, assign) WOAFLowActionType detailActionType;

- (instancetype) initWithWorkflowDetailDictionary: (NSDictionary*)dict
                                 detailActionType: (WOAFLowActionType)detailActionType;

@end
