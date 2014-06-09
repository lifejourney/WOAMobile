//
//  WOAWorkflowTypeListViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAWorkflowTypeListViewController.h"
#import "WOALayout.h"
#import "WOAAppDelegate.h"
#import "WOAFlowController.h"


@interface WOAWorkflowTypeListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *selectedCategoryLabel;
@property (nonatomic, strong) UIButton *filterCategoryButton;
@property (nonatomic, strong) UITableView *listView;

@property (nonatomic, strong) NSDictionary *typeListDictionary;
@property (nonatomic, strong) NSDictionary *categoryDictionary;

- (void) onFilterCategoryButtonAction: (id) sender;

@end

@implementation WOAWorkflowTypeListViewController

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

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedCategoryLabel = [[UILabel alloc] initWithFrame: self.view.frame];
    _selectedCategoryLabel.text = @"全部";
    [_selectedCategoryLabel setTextAlignment: NSTextAlignmentCenter];
    _selectedCategoryLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.view addSubview: _selectedCategoryLabel];
    
    self.filterCategoryButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [_filterCategoryButton setTitle: @"@" forState: UIControlStateNormal];
    [_filterCategoryButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    //[_filterCategoryButton setBackgroundImage: [UIImage imageNamed: @""] forState: UIControlStateNormal];
    _filterCategoryButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_filterCategoryButton addTarget: self action: @selector(onFilterCategoryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _filterCategoryButton];
    
    self.listView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _listView.dataSource = self;
    _listView.delegate = self;
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: _listView];
    
    CGRect selfRect = self.view.frame;
    CGRect navRect = self.navigationController.navigationBar.frame;
    CGFloat contentTopMargin = self.navigationController.navigationBar.isHidden ? 0 : (navRect.origin.y + navRect.size.height);
    contentTopMargin += kWOALayout_DefaultTopMargin;
    
    CGFloat buttonWidth = 44;
    CGFloat buttonHeight = 30;
    _filterCategoryButton.frame = CGRectMake(selfRect.size.width - buttonWidth - kWOALayout_DefaultRightMargin,
                                             contentTopMargin,
                                             buttonWidth,
                                             buttonHeight);
    _selectedCategoryLabel.frame = CGRectMake(kWOALayout_DefaultLeftMargin,
                                              contentTopMargin,
                                              selfRect.size.width - kWOALayout_DefaultLeftMargin - buttonWidth - kWOALayout_DefaultRightMargin,
                                              buttonHeight);
    CGFloat listOriginY = contentTopMargin + buttonHeight + kWOALayout_DefaultTopMargin;
    _listView.frame = CGRectMake(0, listOriginY, selfRect.size.width, selfRect.size.height - listOriginY);
    
    [self.listView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
//    static NSString *moreFeatureTableViewCellIdentifier = @"moreFeatureTableViewCellIdentifier";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: moreFeatureTableViewCellIdentifier];
//    if (!cell)
//        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: moreFeatureTableViewCellIdentifier];
//    else
//    {
//        UIView *subview;
//        
//        do
//        {
//            subview = [cell.contentView.subviews lastObject];
//            
//            if (subview)
//                [subview removeFromSuperview];
//        }
//        while (!subview);
//    }
//    
//    WOAMenuItemModel *itemModel = [self.itemArray objectAtIndex: indexPath.row];
//    
//    cell.textLabel.text = itemModel.title;
//    
//    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 44;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
//    WOAMenuItemModel *itemModel = [self.itemArray objectAtIndex: indexPath.row];
//    NSString *itemID = itemModel.itemID;
//    
//    [tableView deselectRowAtIndexPath: indexPath animated: NO];
//    
//    if ([itemID isEqualToString: kWOAMenuItemKey_Draft])
//    {
//        
//    }
//    else if ([itemID isEqualToString: kWOAMenuItemKey_CheckForUpdate])
//    {
//        [WOACheckForUpdate checkingUpdateFromAppStore: NO];
//    }
//    else if ([itemID isEqualToString: kWOAMenuItemKey_About])
//    {
//        WOAAboutViewController *aboutVC = [[WOAAboutViewController alloc] init];
//        
//        [self presentViewController: aboutVC animated: YES completion: ^{}];
//    }
}

#pragma mark - delegate

- (void) onFilterCategoryButtonAction: (id)sender
{
    
}

#pragma mark - public

- (void) sendRequestForWorkflowTypeList
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate showLoadingViewController];
    
    WOARequestContent *requestContent = [WOARequestContent reqeustContentForWorkflowTypeList];
    [WOAFlowController sendAsynRequestWithContent: requestContent
                                            queue: appDelegate.operationQueue
                              completeOnMainQueue: YES
                                completionHandler:^(WOAResponeContent *responseContent)
    {
        [appDelegate hideLoadingViewController];
        
        if (responseContent.requestResult == WOAHTTPRequestResult_Success)
        {
            self.typeListDictionary = responseContent.bodyDictionary;
        }
        else
        {
            NSLog(@"Get workflow typeList fail: %d, HTTPStatus=%d", responseContent.requestResult, responseContent.HTTPStatus);
        };
        
    }];
}

@end
