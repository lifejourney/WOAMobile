//
//  WOAInitiateWorkflowViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WOAInitiateWorkflowViewController : UIViewController

- (instancetype) initWithWorkflowDetailDictionary: (NSDictionary*)dict;

- (void) sendRequestForWorkflowTypeList;

@end
