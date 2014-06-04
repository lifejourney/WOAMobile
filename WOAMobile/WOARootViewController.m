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


@interface WOARootViewController ()

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
        self.vcArray = [[NSMutableArray alloc] init];
        
        WOAWorkflowTypeListViewController *typeListVC = [[WOAWorkflowTypeListViewController alloc] init];
        typeListVC.navigationItem.title = @"新建工作";
        _initiateWorkflowNavC = [[UINavigationController alloc] initWithRootViewController: typeListVC];
        _initiateWorkflowNavC.tabBarItem.title = @"新建";
        [self.vcArray addObject: _initiateWorkflowNavC];
        
        _todoWorkflowNavC = [[UINavigationController alloc] init];
        _todoWorkflowNavC.tabBarItem.title = @"代办";
        [self.vcArray addObject: _todoWorkflowNavC];
        
        _appliedWorkflowNavC = [[UINavigationController alloc] init];
        _appliedWorkflowNavC.tabBarItem.title = @"搜索";
        [self.vcArray addObject: _appliedWorkflowNavC];
        
        _moreFeatureNavC = [[UINavigationController alloc] init];
        _moreFeatureNavC.tabBarItem.title = @"更多";
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

@end






