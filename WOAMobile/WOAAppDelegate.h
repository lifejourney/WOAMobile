//
//  WOAAppDelegate.h
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WOARootViewController;

@interface WOAAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong, readonly) WOARootViewController *rootViewController;

@property (copy) NSString *sessionID;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, assign) BOOL isLaunchByAPNS;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (void) presentLoginViewController: (BOOL)animated;
- (void) dismissLoginViewController: (BOOL)animated;
- (void) showLoadingViewController;
- (void) showTransparentLoadingView;
- (void) hideLoadingViewController;
- (void) switchToInitiateWorkflow;
- (void) switchToTodoWorkflow;

@end

/**before public
 remove pragram mark
 
 */
/**issue
 1. length for account and password
 2. http request error for login fail, session invalid
 3. protocol:
 -- phoneID --> deviceToken, and should be string
 -- checkSum: how to calculate
 -- prefer to be string type
 -- sessionID --> string type
 -- should define the component order? Test JSON order and dictionary key order?
 -- what would return for session invalid.

 */

/** RC Research
 RCMenuController
 AppDelegate:
    tabBarController
 
 deviceToken: translate
 */

/** Research
 tabBarItem怎样只有标题，没有图片
 tableView, reuseIdentifier
 
 */

/**
 App:
    App status response: 
        start/terminate
        forground
        background
        activity for network response
    ViewControllers:
        RootViewController -- TabBar
        Login
        Loading
        InitiateWorkflowNavC:
            WorkflowCategoryListVC
            WorkflowTypeListVC
            InitiateWorkflowVC
            SelectNextStepVC
            SelectNextReviewerVC
            SubmitResult
        TodoWorkflowNavC:
            TodoWorkflowListVC
            ReviewWorkflowVC
            SelectNextStepVC
            SelectNextReviewerVC
            SubmitResult
        AppliedWorkflowNavC
            AppliedWorkflowVC
            WorkflowDetailVC
        MoreFeatureNavC
            MoreFeatureVC
    Dictionary To View Item
    View Item to Dictionary
    TO-DO: 
        APN
        Attachment
 Controller:
    LocalStorage,
    Session,
 
    FLowController,
        FlowType
        FlowSteps
 Model:
    PropertyInfo, 
    Connection, Requester, JSON Parser/Serializer
 Utility: 
    BrandData
 */

/** day

 5.31: 4h
 6.1: 8h
 6.3: 2h
 6.4: 8h
 6.5: 8h
 6.6: 8h
*/