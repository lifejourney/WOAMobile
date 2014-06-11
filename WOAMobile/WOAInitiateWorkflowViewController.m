//
//  WOAInitiateWorkflowViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAInitiateWorkflowViewController.h"
#import "WOAAppDelegate.h"
#import "WOALayout.h"
#import "WOADynamicLabelTextField.h"


@interface WOAInitiateWorkflowViewController () <UITextFieldDelegate>

@property (nonatomic, copy) NSString *workID;
@property (nonatomic, copy) NSString *tableID;
@property (nonatomic, strong) NSDictionary *detailDictionary;

@end

@implementation WOAInitiateWorkflowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype) init
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
    }
    
    return self;
}

- (instancetype) initWithWorkflowDetailDictionary: (NSDictionary*)dict
{
    if (self = [self init])
    {
        self.detailDictionary = dict;
    }
    
    return self;
}

- (CGFloat) createTitleLabelInView: (UIView*)view fromOrigin: (CGPoint)fromOrigin sizeWidth: (CGFloat)sizeWidth
{
    CGFloat totalHeight = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLabel.text = @"Hello";
    
    CGRect titleRect = CGRectMake(100, 400, 100, 30);
    [titleLabel setFrame: titleRect];
    [view addSubview: titleLabel];
    
    totalHeight += titleRect.origin.y + titleRect.size.height;
    
    return totalHeight;
}

- (CGFloat) createDynamicWorkflowItemInView: (UIView*)view fromOrigin: (CGPoint)fromOrigin sizeWidth: (CGFloat)sizeWidth
{
    CGFloat totalHeight = fromOrigin.y;
    CGRect itemRect;
    
    return totalHeight;
    
}

- (CGFloat) createDynamicComponentsInView: (UIView*)view;
{
    CGFloat totalHeight = 0;
    CGFloat contentWidth = view.frame.size.width - kWOALayout_DefaultLeftMargin - kWOALayout_DefaultRightMargin;
    
    totalHeight = [self createTitleLabelInView: view
                                    fromOrigin: CGPointMake(kWOALayout_DefaultLeftMargin, totalHeight)
                                     sizeWidth: contentWidth];
    totalHeight = [self createDynamicWorkflowItemInView: view
                                             fromOrigin: CGPointMake(kWOALayout_DefaultLeftMargin, totalHeight)
                                              sizeWidth: contentWidth];
    
    totalHeight += kWOALayout_DefaultBottomMargin;
    
    return totalHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"返回"
                                                                          style: UIBarButtonItemStylePlain
                                                                         target: self
                                                                         action: @selector(backAction:)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target: self
                                                                          action: @selector(submitAction:)];
    self.navigationItem.title = @"新建工作";
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: self.view.frame];
    scrollView.backgroundColor = [UIColor orangeColor];
    
    CGFloat contentHeight = [self createDynamicComponentsInView: scrollView];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, contentHeight);
    
    [self.view addSubview: scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backAction: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) submitAction: (id)sender
{
    
}

@end
