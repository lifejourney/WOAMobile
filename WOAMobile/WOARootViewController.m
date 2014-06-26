//
//  WOARootViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOARootViewController.h"
#import "WOAWorkflowTypeListViewController.h"
#import "WOAWorkflowFormListViewController.h"
#import "WOAMoreFeatureViewController.h"
#import "UINavigationController+RootViewController.h"


@interface WOARootViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *vcArray;
@property (nonatomic, strong) UINavigationController *initiateWorkflowNavC;
@property (nonatomic, strong) UINavigationController *todoWorkflowNavC;
@property (nonatomic, strong) UINavigationController *appliedWorkflowNavC;
@property (nonatomic, strong) UINavigationController *moreFeatureNavC;

@end

@implementation WOARootViewController

@synthesize initiateWorkflowNavC = _initiateWorkflowNavC,
            todoWorkflowNavC = _todoWorkflowNavC,
            appliedWorkflowNavC = _appliedWorkflowNavC,
            moreFeatureNavC = _moreFeatureNavC;

#pragma mark - lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (instancetype) init
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        self.tabBar.backgroundImage = [UIImage imageNamed: @"TabBarBg"];
        
        self.vcArray = [[NSMutableArray alloc] init];
        
        UITabBarItem *typeListItem = [[UITabBarItem alloc] initWithTitle: @"新建"
                                                                   image: [[UIImage imageNamed: @"NewWorkFlowIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]
                                                           selectedImage: [[UIImage imageNamed: @"NewWorkFlowSelectedIcon"]  imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *todoItem = [[UITabBarItem alloc] initWithTitle: @"代办"
                                                               image: [[UIImage imageNamed: @"TodoWorkFlowIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage: [[UIImage imageNamed: @"TodoWorkFlowSelectedIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *historyItem = [[UITabBarItem alloc] initWithTitle: @"搜索"
                                                                  image: [[UIImage imageNamed: @"SearchWorkFlowIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]
                                                          selectedImage: [[UIImage imageNamed: @"SearchWorkFlowSelectedIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle: @"更多"
                                                               image: [[UIImage imageNamed: @"MoreFeatureIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage: [[UIImage imageNamed: @"MoreFeatureSelectedIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
        
        WOAWorkflowTypeListViewController *typeListVC = [[WOAWorkflowTypeListViewController alloc] init];
        _initiateWorkflowNavC = [[UINavigationController alloc] initWithRootViewController: typeListVC];
        _initiateWorkflowNavC.tabBarItem = typeListItem;
        [self.vcArray addObject: _initiateWorkflowNavC];
        
        WOAWorkflowFormListViewController *todoListVC = [[WOAWorkflowFormListViewController alloc] init];
        todoListVC.listActionType = WOAFLowActionType_GetTodoWorkflowList;
        _todoWorkflowNavC = [[UINavigationController alloc] initWithRootViewController: todoListVC];
        _todoWorkflowNavC.tabBarItem = todoItem;
        [self.vcArray addObject: _todoWorkflowNavC];
        
        WOAWorkflowFormListViewController *historyListVC = [[WOAWorkflowFormListViewController alloc] init];
        historyListVC.listActionType = WOAFLowActionType_GetHistoryWorkflowList;
        _appliedWorkflowNavC = [[UINavigationController alloc] initWithRootViewController: historyListVC];
        _appliedWorkflowNavC.tabBarItem = historyItem;
        [self.vcArray addObject: _appliedWorkflowNavC];
        
        WOAMoreFeatureViewController *moreFeatureVC = [[WOAMoreFeatureViewController alloc] init];
        _moreFeatureNavC = [[UINavigationController alloc] initWithRootViewController: moreFeatureVC];
        _moreFeatureNavC.tabBarItem = moreItem;
        [self.vcArray addObject: _moreFeatureNavC];
        
        self.delegate = self;
        self.viewControllers = self.vcArray;
    }
    
    return self;
}

#pragma mark - Properties

#pragma mark - Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate

- (BOOL) tabBarController: (UITabBarController *)tabBarController shouldSelectViewController: (UIViewController *)viewController
{
    return YES;
}

- (void) tabBarController: (UITabBarController *)tabBarController didSelectViewController: (UIViewController *)viewController
{
    UINavigationController *selectedNavC = (UINavigationController *)viewController;
    
    if ([selectedNavC isRootViewControllerOnTop])
    {
        NSObject<WOAStartWorkflowActionReqeust> *selectedRootVC = (NSObject<WOAStartWorkflowActionReqeust> *)[selectedNavC rootViewController];
        
        if ([selectedRootVC conformsToProtocol: @protocol(WOAStartWorkflowActionReqeust)])
            [selectedRootVC sendRequestByActionType];
    }
}

#pragma mark - public

- (void) switchToInitiateWorkflow: (BOOL) popToRootVC shouldRefresh: (BOOL)shouldRefresh
{
    [self setSelectedIndex: 0];
    
    if (popToRootVC)
    {
        [_initiateWorkflowNavC popToRootViewControllerAnimated: YES];
        
        if (shouldRefresh)
        {
            NSObject<WOAStartWorkflowActionReqeust> *typeListVC;
            typeListVC = (WOAWorkflowTypeListViewController*)[_initiateWorkflowNavC rootViewController];
            
            [typeListVC sendRequestByActionType];
        }
    }
}

- (void) switchToTodoWorkflow: (BOOL) popToRootVC shouldRefresh: (BOOL)shouldRefresh
{
    [self setSelectedIndex: 1];
    
    if (popToRootVC)
    {
        [_todoWorkflowNavC popToRootViewControllerAnimated: YES];
        
        if (shouldRefresh)
        {
            NSObject<WOAStartWorkflowActionReqeust> *formListVC;
            formListVC = (WOAWorkflowTypeListViewController*)[_todoWorkflowNavC rootViewController];
            
            [formListVC sendRequestByActionType];
        }
    }
}

@end






