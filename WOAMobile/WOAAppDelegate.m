//
//  WOAAppDelegate.m
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAAppDelegate.h"
#import "WOARootViewController.h"
#import "WOASplashViewController.h"
#import "WOAStartSettingViewController.h"
#import "WOALoginViewController.h"
#import "WOALoadingViewController.h"
#import "WOAFlowController.h"
#import "NSData+HexadecimalRepresentation.h"
#import "UIColor+AppTheme.h"


@interface WOAAppDelegate () <WOASplashViewControllerDelegate, WOAStartSettingViewControllerDelegate>

@property (nonatomic, strong) WOALoadingViewController *loadingVC;
@property (nonatomic, strong) WOALoginViewController *loginVC;

@end


@implementation WOAAppDelegate

@synthesize rootViewController=_rootViewController;
@synthesize loginVC = _loginVC;

#pragma mark - lifecycle

- (instancetype) init
{
    if (self = [super init])
    {
        self.loadingVC = nil;
        
        self.sessionID = @"";
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount: 1];
    }
    
    return self;
}

#pragma mark - Properties

- (WOARootViewController*) rootViewController
{
    return _rootViewController;
}

- (UIViewController*) presentedViewController
{
    UIViewController *presentedVC = self.rootViewController.presentedViewController;
    if (!presentedVC)
        presentedVC = self.rootViewController;
    
    return presentedVC;
}

- (WOALoginViewController*) loginVC
{
    if (!_loginVC)
    {
        _loginVC = [[WOALoginViewController alloc] init];
    }
    
    return _loginVC;
}

#pragma mark - application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootViewController = [[WOARootViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    
    self.loadingVC = [[WOALoadingViewController alloc] init];
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector: @selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType settingType = UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes: settingType categories: nil];
        [app registerUserNotificationSettings: setting];
    }
    else
    {
        UIRemoteNotificationType apnsType = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: apnsType];
    }
    
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor: [UIColor mainItemBgColor]];
    
    NSDictionary *titleAttributeForNormalState = @{NSForegroundColorAttributeName: [UIColor tabbarItemNormalColor]};
    NSDictionary *titleAttributeForSelectedState = @{NSForegroundColorAttributeName: [UIColor tabbarItemSelectedColor]};
    NSDictionary *navigationItemAttribute = @{NSForegroundColorAttributeName: [UIColor navigationItemNormalColor]};
    
    [[UITabBarItem appearanceWhenContainedIn: [UITabBar class], nil] setTitleTextAttributes: titleAttributeForNormalState
                                                                                   forState: UIControlStateNormal];
    [[UITabBarItem appearanceWhenContainedIn: [UITabBar class], nil] setTitleTextAttributes: titleAttributeForSelectedState
                                                                                   forState: UIControlStateSelected];
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], nil] setTitleTextAttributes: navigationItemAttribute
                                                                                             forState: UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], nil] setTitleTextAttributes: navigationItemAttribute
                                                                                             forState: UIControlStateHighlighted];
    [[UINavigationBar appearanceWhenContainedIn: [UINavigationController class], nil] setBackgroundImage: [UIImage imageNamed: @"NavigationBarBg"]
                                                                                           forBarMetrics: UIBarMetricsDefault];
    
    [self.window makeKeyAndVisible];
    
    UIViewController *presentedVC = [self presentedViewController];
    UIViewController *splashVC = [[WOASplashViewController alloc] initWithDelegate: self];
    
    [presentedVC presentViewController: splashVC animated: NO completion: ^{}];
    
    return YES;
}

- (void) application: (UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)deviceToken
{
    //TO-DO: resend login when changed?
    //TO-DO: resend login when nil -> string
    
    if (self.sessionID && !self.deviceToken)
    {
        NSLog(@"get device token after login: %@", _deviceToken);
    }
    
    self.deviceToken = [deviceToken hexadecimalRepresentation];
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToke: %@", _deviceToken);
}

- (void) application: (UIApplication *)application didFailToRegisterForRemoteNotificationsWithError: (NSError *)error
{
    //TO-DO: resend login?
    self.deviceToken = nil;
    
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) splashViewDidHiden: (BOOL)showStartSetting
{
    if (showStartSetting)
    {
        UIViewController *presentedVC = [self presentedViewController];
        WOAStartSettingViewController *settingVC = [[WOAStartSettingViewController alloc] initWithDelegate: self];
        
        [presentedVC presentViewController: settingVC
                                  animated: YES
                                completion: nil];
    }
    else
    {
        [self presentLoginViewController: YES animated: NO];
    }
}

- (void) startSettingViewDidHiden
{
    [self presentLoginViewController: YES animated: NO];
}

#pragma mark - Public

- (void) presentLoginViewController: (BOOL)loginImmediately animated: (BOOL)animated
{
    UIViewController *presentedVC = [self presentedViewController];
    
    if (![presentedVC isKindOfClass: [self.loginVC class]])
    {
        [presentedVC presentViewController: self.loginVC
                                  animated: animated
                                completion: ^
        {
            if (loginImmediately)
                [self.loginVC tryLogin];
        }];
    }
}

- (void) dismissLoginViewController: (BOOL)animated
{
    [self.loginVC dismissViewControllerAnimated: animated completion: ^{}];
}

- (void) showLoadingViewController: (CGFloat)backgroundAlpha
{
    self.loadingVC.view.alpha = backgroundAlpha;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview: self.loadingVC.view];
}

- (void) showLoadingViewController
{
    [self showLoadingViewController: 0.3];
}

- (void) showTransparentLoadingView
{
    [self showLoadingViewController: 0];
}

- (void) hideLoadingViewController
{
    [self.loadingVC.view removeFromSuperview];
}

- (void) sendRequest: (WOARequestContent*)requestContent
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
           onFailure: (void (^)(WOAResponeContent *responseContent))failureHandler
{
    [self showLoadingViewController];
    
    [WOAFlowController sendAsynRequestWithContent: requestContent
                                            queue: self.operationQueue
                              completeOnMainQueue: YES
                                completionHandler: ^(WOAResponeContent *responseContent)
     {
         [self hideLoadingViewController];
         
         if ((responseContent.requestResult == WOAHTTPRequestResult_Success) && successHandler)
         {
             successHandler(responseContent);
         }
         else if (failureHandler)
         {
             failureHandler(responseContent);
         }
     }];
}

@end




