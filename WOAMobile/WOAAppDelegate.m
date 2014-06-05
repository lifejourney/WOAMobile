//
//  WOAAppDelegate.m
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAAppDelegate.h"
#import "WOARootViewController.h"
#import "WOALoginViewController.h"
#import "WOALoadingViewController.h"


@interface WOAAppDelegate ()

@property (nonatomic, strong) WOALoadingViewController *loadingVC;

@end


@implementation WOAAppDelegate

@synthesize rootViewController=_rootViewController;

#pragma mark - lifecycle

- (instancetype) init
{
    if (self = [super init])
    {
        self.loadingVC = nil;
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

#pragma mark - application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootViewController = [[WOARootViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    //TO-DO
    //[self.window addSubview: _rootViewController.view];
    
    self.loadingVC = [[WOALoadingViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    [self presentLoginViewController: NO];
    
    return YES;
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

#pragma mark - Public

- (void) presentLoginViewController: (BOOL)animated
{
    WOALoginViewController *loginVC = [[WOALoginViewController alloc] init];
    
    UIViewController *presentedVC = [self presentedViewController];
    
    [presentedVC presentViewController: loginVC
                              animated: animated
                            completion: ^{}];
}

- (void) showLoadingViewController
{
    [[[UIApplication sharedApplication] keyWindow] addSubview: self.loadingVC.view];
}

- (void) hideLoadingViewController
{
    [self.loadingVC.view removeFromSuperview];
}

@end




