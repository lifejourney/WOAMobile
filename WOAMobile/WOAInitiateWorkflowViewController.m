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


@interface WOAInitiateWorkflowViewController () <WOADynamicLabelTextFieldDelegate>

@property (nonatomic, copy) NSString *workID;
@property (nonatomic, copy) NSString *tableID;
@property (nonatomic, strong) NSDictionary *detailDictionary;

@property (nonatomic, strong) UITextField *latestFirstResponderTextField;

- (void) tapOutsideKeyboardAction;

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
        
        self.workID = [WOAPacketHelper workIDFromPacketDictionary: dict];
        self.tableID = [WOAPacketHelper tableIDFromPacketDictionary: dict];
    }
    
    return self;
}

- (CGFloat) createTitleLabelInView: (UIView*)scrollView fromOrigin: (CGPoint)fromOrigin sizeWidth: (CGFloat)sizeWidth
{
    CGFloat totalHeight = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLabel.text = [WOAPacketHelper tableNameFromPacketDictionary: self.detailDictionary];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect titleRect = CGRectMake(fromOrigin.x, fromOrigin.y, sizeWidth, kWOALayout_ItemCommonHeight);
    [titleLabel setFrame: titleRect];
    [scrollView addSubview: titleLabel];
    
    totalHeight = titleRect.size.height;
    
    return totalHeight;
}

- (CGFloat) createGroupSplitLine: (UIView*)view fromOrigin: (CGPoint)fromOrigin sizeWidth: (CGFloat)sizeWidth
{
    CGFloat totalHeight = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLabel.text = @"";
    titleLabel.backgroundColor = [UIColor blackColor];
    
    CGFloat splitTopMargin = 4;
    CGRect titleRect = CGRectMake(fromOrigin.x, fromOrigin.y + splitTopMargin, sizeWidth, 1);
    [titleLabel setFrame: titleRect];
    [view addSubview: titleLabel];
    
    totalHeight = titleRect.size.height + splitTopMargin;
    
    return totalHeight;
}

- (CGFloat) createDynamicWorkflowItemInView: (UIView*)scrollView fromOrigin: (CGPoint)fromOrigin sizeWidth: (CGFloat)sizeWidth
{
    CGFloat itemOriginX = fromOrigin.x;
    CGFloat itemOriginY = fromOrigin.y;
    CGFloat itemSizeWidth = sizeWidth;
    CGFloat itemSizeHeight = 1; //just for placeholder
    CGFloat totalHeight = 0;
    
    NSArray *itemGroupsArray = [WOAPacketHelper itemsArrayFromPacketDictionary: self.detailDictionary];
    WOADynamicLabelTextField *itemTextField;
    CGRect rect;
    
    for (NSInteger groupIndex = 0; groupIndex < [itemGroupsArray count]; groupIndex++)
    {
        NSArray *itemsArray = [itemGroupsArray objectAtIndex: groupIndex];
        
        for (NSInteger itemIndex = 0; itemIndex < [itemsArray count]; itemIndex++)
        {
            NSDictionary *itemModel = [itemsArray objectAtIndex: itemIndex];
            rect = CGRectMake(itemOriginX, itemOriginY, itemSizeWidth, itemSizeHeight);
            
            itemTextField = [[WOADynamicLabelTextField alloc] initWithFrame: rect
                                                          popoverShowInView: self.view
                                                                    section: groupIndex
                                                                        row: itemIndex
                                                                  itemModel: itemModel];
            itemTextField.delegate = self;
            
            [scrollView addSubview: itemTextField];
            
            totalHeight += itemTextField.frame.size.height;
            itemOriginY += itemTextField.frame.size.height;
        }
        
        if ([itemsArray count] > 0 && (groupIndex + 1) < [itemGroupsArray count])
        {
            CGPoint splitLineOrigin = CGPointMake(itemOriginX, itemOriginY);
            CGFloat splitHeight = [self createGroupSplitLine: scrollView
                                                  fromOrigin: splitLineOrigin
                                                   sizeWidth: itemSizeWidth];
            
            totalHeight += splitHeight;
            itemOriginY += splitHeight;
        }
    }
    
    return totalHeight;
    
}

- (CGFloat) createDynamicComponentsInView: (UIView*)scrollView;
{
    CGFloat totalHeight = 0;
    CGFloat contentWidth = scrollView.frame.size.width - kWOALayout_DefaultLeftMargin - kWOALayout_DefaultRightMargin;
    
    totalHeight += [self createTitleLabelInView: scrollView
                                     fromOrigin: CGPointMake(kWOALayout_DefaultLeftMargin, totalHeight)
                                      sizeWidth: contentWidth];
    totalHeight += [self createDynamicWorkflowItemInView: scrollView
                                              fromOrigin: CGPointMake(kWOALayout_DefaultLeftMargin, totalHeight)
                                               sizeWidth: contentWidth];
    
    totalHeight += kWOALayout_DefaultBottomMargin;
    
    return totalHeight;
}

- (void) tapOutsideKeyboardAction
{
    if ([self.latestFirstResponderTextField isFirstResponder])
        [self.latestFirstResponderTextField resignFirstResponder];
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
    scrollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat contentHeight = [self createDynamicComponentsInView: scrollView];
    //TO-DO, add for keyboard height
    contentHeight += 200;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, contentHeight);
    
    [self.view addSubview: scrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                 action: @selector(tapOutsideKeyboardAction)];
    [scrollView addGestureRecognizer: tapGesture];
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

#pragma mark - WOADynamicLabelTextFieldDelegate
- (void) textFieldDidBecameFirstResponder: (UITextField *)textField
{
    self.latestFirstResponderTextField = textField;
}

- (void) textFieldTryBeginEditing: (UITextField *)textField allowEditing: (BOOL)allowEditing
{
    if (!allowEditing)
    {
        [self.latestFirstResponderTextField resignFirstResponder];
    }
}

@end
