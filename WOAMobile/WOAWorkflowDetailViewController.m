//
//  WOAWorkflowDetailViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAWorkflowDetailViewController.h"
#import "WOAAppDelegate.h"
#import "UINavigationController+RootViewController.h"
#import "WOAStartWorkflowActionReqeust.h"
#import "WOALayout.h"
#import "WOADynamicLabelTextField.h"
#import "WOAPickerViewController.h"
#import "WOASelectNextReviewerViewController.h"


@interface WOAWorkflowDetailViewController () <WOADynamicLabelTextFieldDelegate,
                                                WOAPickerViewControllerDelegate,
                                                UIAlertViewDelegate>

@property (nonatomic, copy) NSString *workID;
@property (nonatomic, copy) NSString *tableID;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, strong) NSDictionary *detailDictionary;

@property (nonatomic, strong) WOADynamicLabelTextField *attachmentField;

@property (nonatomic, strong) NSArray *processArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *latestFirstResponderTextField;
@property (nonatomic, strong) WOAPickerViewController *pickerVC;

- (void) tapOutsideKeyboardAction;

@end

@implementation WOAWorkflowDetailViewController

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
                                 detailActionType: (WOAFLowActionType)detailActionType
{
    if (self = [self init])
    {
        self.detailDictionary = dict;
        self.detailActionType = detailActionType;
        
        self.workID = [WOAPacketHelper workIDFromPacketDictionary: dict];
        self.tableID = [WOAPacketHelper tableIDFromPacketDictionary: dict];
        self.tableName = [WOAPacketHelper tableNameFromPacketDictionary: dict];
    }
    
    return self;
}

- (CGFloat) createTitleLabelInView: (UIView*)scrollView fromOrigin: (CGPoint)fromOrigin sizeWidth: (CGFloat)sizeWidth
{
    CGFloat totalHeight = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLabel.text = self.tableName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor workflowTitleViewBgColor];
    titleLabel.textColor = [UIColor textHighlightedColor];
    
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
    titleLabel.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.1];
    
    CGFloat splitTopMargin = kWOALayout_ItemTopMargin;
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
    UINavigationController *hostNavigationController = self.navigationController;
    
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
                                                                 isEditable: (_detailActionType != WOAFLowActionType_GetWorkflowViewDetail)
                                                                  itemModel: itemModel];
            itemTextField.delegate = self;
            itemTextField.hostNavigation = hostNavigationController;
            
            if (_detailActionType == WOAFLowActionType_InitiateWorkflow)
            {
                [itemTextField selectDefaultValueFromPickerView];
            }
            
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
                                     fromOrigin: CGPointMake(0, totalHeight)
                                      sizeWidth: scrollView.frame.size.width];
    totalHeight += [self createDynamicWorkflowItemInView: scrollView
                                              fromOrigin: CGPointMake(kWOALayout_DefaultLeftMargin, totalHeight)
                                               sizeWidth: contentWidth];
    
    totalHeight += kWOALayout_DefaultBottomMargin;
    
    return totalHeight;
}

- (WOADynamicLabelTextField*) selectedAttachmentField
{
    for (UIView *subView in self.scrollView.subviews)
    {
        if (![subView isKindOfClass: [WOADynamicLabelTextField class]])
            continue;
        
        WOADynamicLabelTextField *subTextField = (WOADynamicLabelTextField*)subView;
        if (subTextField.imageFullFileNameArray.count > 0)
        {
            return subTextField;
        }
    }
    
    return nil;
}

- (NSArray*) allItemsArray
{
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    for (UIView *subView in self.scrollView.subviews)
    {
        if (![subView isKindOfClass: [WOADynamicLabelTextField class]])
            continue;
        
        NSDictionary *itemDict = [(WOADynamicLabelTextField*)subView toDataModelWithIndexPath];
        
        [itemsArray addObject: itemDict];
    }
    
//    NSSortDescriptor *sectionKey = [[NSSortDescriptor alloc] initWithKey: kWOAItemIndexPath_SectionKey ascending: YES];
//    NSSortDescriptor *rowKey = [[NSSortDescriptor alloc] initWithKey: kWOAItemIndexPath_RowKey ascending: YES];
//    NSArray *sortedArray = [itemsArray sortedArrayUsingDescriptors: [NSArray arrayWithObjects: sectionKey, rowKey, nil]];
    NSArray *sortedArray = [NSArray arrayWithArray: itemsArray];
    
    NSInteger section = -1;
    NSMutableArray *itemsGroup = [[NSMutableArray alloc] init];
    NSMutableArray *aGroup = nil;
    NSDictionary *currentItem;
    NSNumber *itemSectionNum;
    for (NSUInteger i = 0; i < [sortedArray count]; i++)
    {
        currentItem = [sortedArray objectAtIndex: i];
        itemSectionNum = [currentItem objectForKey: kWOAItemIndexPath_SectionKey];
        
        if (itemSectionNum.integerValue != section)
        {
            section = itemSectionNum.integerValue;
            
            aGroup = [[NSMutableArray alloc] init];
            [itemsGroup addObject: aGroup];
        }
        
        [aGroup addObject: [WOAPacketHelper itemWithoutIndexPathFromDictionary: currentItem]];
    }
    
    return itemsGroup;
}

- (void) parseCommitWorkflowResponse: (NSDictionary*)content
{
    NSArray *itemsArray = [WOAPacketHelper itemsArrayFromPacketDictionary: content];
    
    NSSortDescriptor *processKey = [[NSSortDescriptor alloc] initWithKey: kWOAKey_ProcessID ascending: YES];
    self.processArray = [itemsArray sortedArrayUsingDescriptors: [NSArray arrayWithObjects: processKey, nil]];
    
    NSArray *processNameArray = [WOAPacketHelper processNameArrayFromProcessArray: self.processArray];
    
    _pickerVC = [[WOAPickerViewController alloc] initWithDelgate: self
                                                           title: @""
                                                       dataModel: processNameArray
                                                     selectedRow: -1];
    _pickerVC.shouldShowBackBarItem = NO;
    _pickerVC.shouldPopWhenSelected = NO;
    
    [self.navigationController pushViewController: _pickerVC animated: YES];
}

- (void) parseSelectNextStepResponse: (NSDictionary*)content
{
    NSArray *itemsArray = [WOAPacketHelper itemsArrayFromPacketDictionary: content];
    
    //TO-DO,
    if (itemsArray && [itemsArray count] > 0)
    {
        //TO-DO, asssume same workID
        WOASelectNextReviewerViewController *nextReviewerVC;
        nextReviewerVC = [[WOASelectNextReviewerViewController alloc] initWithWorkID: self.workID
                                                                  accountsGroupArray: itemsArray];
        
        [self.navigationController pushViewController: nextReviewerVC animated: YES];
    }
    else
    {
        //TO-DO
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil
                                                            message: @"已完结"
                                                           delegate: self
                                                  cancelButtonTitle: @"确定"
                                                  otherButtonTitles: nil, nil];
        
        [alertView show];
    }
}

- (void) tapOutsideKeyboardAction
{
    if ([self.latestFirstResponderTextField isFirstResponder])
        [self.latestFirstResponderTextField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target: self
                                                                          action: @selector(submitAction:)];
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    
    //TO-DO: Draft
    UILabel *titleView = [WOALayout lableForNavigationTitleView: @""];
    if (_detailActionType == WOAFLowActionType_InitiateWorkflow)
    {
        titleView.text = @"新建工作";
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    else if (_detailActionType == WOAFLowActionType_GetWorkflowFormDetail)
    {
        titleView.text = @"待办工作";
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    else  if (_detailActionType == WOAFLowActionType_GetWorkflowViewDetail)
    {
        titleView.text = @"事务查询";
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        titleView.text = @"";
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.navigationItem.titleView = titleView;
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame: self.view.frame];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat contentHeight = [self createDynamicComponentsInView: _scrollView];
    //TO-DO, add for keyboard height
    contentHeight += 200;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, contentHeight);
    
    [self.view addSubview: _scrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                 action: @selector(tapOutsideKeyboardAction)];
    [_scrollView addGestureRecognizer: tapGesture];
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

- (void) sendRequestWithContent: (WOARequestContent*)requestContent
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate sendRequest: requestContent
                  onSuccuess:^(WOAResponeContent *responseContent)
     {
         if (responseContent.flowActionType == WOAFLowActionType_UploadAttachment)
         {
             [self.attachmentField.imageURLArray removeAllObjects];
             for (NSInteger index = 0; index < responseContent.multiBodyArray.count; index++)
             {
                 NSDictionary *bodyDictionary = responseContent.multiBodyArray[index];
                 NSString *fileURL = [WOAPacketHelper resultUploadedFileNameFromPacketDictionary: bodyDictionary];
                 [self.attachmentField.imageURLArray addObject: fileURL];
             }
             
             WOARequestContent *initiateRequestContent = [WOARequestContent contentForInitiateWorkflow: self.workID
                                                                                               tableID: self.tableID
                                                                                             tableName: self.tableName
                                                                                            itemsArray: [self allItemsArray]];
             
             [self sendRequestWithContent: initiateRequestContent];
         }
         else
         {
             [self parseCommitWorkflowResponse: responseContent.bodyDictionary];
         }
         
     }
                   onFailure:^(WOAResponeContent *responseContent)
     {
         if (responseContent.flowActionType == WOAFLowActionType_UploadAttachment)
             NSLog(@"Upload attachment fail.");
         else
             NSLog(@"Initiate workflow fail: %lu, HTTPStatus=%ld", responseContent.requestResult, (long)responseContent.HTTPStatus);
     }];
}

- (void) submitAction: (id)sender
{
    [self tapOutsideKeyboardAction];
    
    //WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent;
    
    //TO-DO: WOAFLowActionType_GetDraftWorkflowList
    if (_detailActionType == WOAFLowActionType_InitiateWorkflow)
    {
        //TO-DO: Only support one attachment field
        self.attachmentField = [self selectedAttachmentField];
        if (self.attachmentField)
        {
            requestContent = [WOARequestContent contentForUploadAttachment: self.workID
                                                                   tableID: self.tableID
                                                                    itemID: @"0"
                                                             filePathArray: self.attachmentField.imageFullFileNameArray
                                                                titleArray: self.attachmentField.imageTitleArray];
        }
        else
        {
            requestContent = [WOARequestContent contentForInitiateWorkflow: self.workID
                                                                   tableID: self.tableID
                                                                 tableName: self.tableName
                                                                itemsArray: [self allItemsArray]];
        }
    }
    //TO-DO: 待办单，可以提交附件吗? itemID
    else if (_detailActionType == WOAFLowActionType_GetWorkflowFormDetail)
    {
        //TO-DO: could commit unwritable?
        requestContent = [WOARequestContent contentForReviewWorkflow: self.workID
                                                          itemsArray: [self allItemsArray]];
    }
    else
    {
        //TO-DO
        //WOAFLowActionType_GetWorkflowViewDetail
        //Draft
        return;
    }
    
    [self sendRequestWithContent: requestContent];
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

#pragma mark -

- (void) pickerViewController: (WOAPickerViewController *)pickerViewController
                  selectAtRow: (NSInteger)row
                fromDataModel:(NSArray *)dataModel
{
    if (row >= 0)
    {
        //TO-DO: assume that workID is same to preview step
        NSString *processID = [WOAPacketHelper processIDFromDictionary: [self.processArray objectAtIndex: row]];
        
        WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        WOARequestContent *requestContent = [WOARequestContent contentForSelectNextStep: self.workID
                                                                              processID: processID];
        
        [appDelegate sendRequest: requestContent
                      onSuccuess:^(WOAResponeContent *responseContent)
         {
             [self parseSelectNextStepResponse: responseContent.bodyDictionary];
             
         }
                       onFailure:^(WOAResponeContent *responseContent)
         {
             NSLog(@"SelectNextStep [Initiate workflow] fail: %lu, HTTPStatus=%ld", responseContent.requestResult, (long)responseContent.HTTPStatus);
         }];
    }
    
    _pickerVC = nil;
}

- (void) pickerViewControllerCancelled: (WOAPickerViewController *)pickerViewController
{
    //TO-DO
    //could just resubmit? or should popop up to top
    
    _pickerVC = nil;
}

#pragma mark - UIAlertView
- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    //TO-DO
    [self.navigationController popToRootViewControllerAnimated: YES];
    
    UIViewController *navRootVC = [self.navigationController rootViewController];
    if ([navRootVC respondsToSelector: @selector(sendRequestByActionType)])
    {
        [(NSObject<WOAStartWorkflowActionReqeust>*)navRootVC sendRequestByActionType];
    }
}

@end
