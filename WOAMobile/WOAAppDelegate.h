//
//  WOAAppDelegate.h
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOARequestContent.h"
#import "WOAResponeContent.h"


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

- (void) sendRequest: (WOARequestContent*)requestContent
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
           onFailure: (void (^)(WOAResponeContent *responseContent))failureHandler;

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
 -- the item count in response isn't needed.
 -- 日期选择器, date format
 -- int: int32? int64?
 -- tableName & name ==> tableName
    itmes --> items
 -- dateTime: date, time, dateTime
 

 4. Needed edge case:
 -- connection error: login, workflow
 */

/** RC Research
 RCMenuController
 AppDelegate:
    tabBarController
 RCSendMessageView
 
 deviceToken: translate
 */

/** Research
 tabBarItem怎样只有标题，没有图片
 tableView, reuseIdentifier
 
 在navigation的VC里，为什么加一个table view，就可以自动调整好位置
 而其他的不行?
 怎样让加进去的view 自动在navigation bar的下面?
 UIPickerView的整体高度怎么自定义
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
 6.7: 2h
 6.8: 4h
 6.9: 8h
 6.10: 6h
 6.11: 4h
*/