//
//  WOAMoreFeatureViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMoreFeatureViewController.h"
#import "WOAAppDelegate.h"
#import "WOAMenuItemModel.h"
#import "WOACheckForUpdate.h"
#import "WOAAboutViewController.h"


#define kWOAMenuItemKey_Seperator @"seperator"
#define kWOAMenuItemKey_Draft @"draft"
#define kWOAMenuItemKey_CheckForUpdate @"update"
#define kWOAMenuItemKey_About @"about"
#define kWOAMenuItemKey_Logout @"logout"


@interface WOAMoreFeatureViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WOAMoreFeatureViewController

#pragma mark - lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype) init
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        WOAMenuItemModel *itemCheckForUpdate = [WOAMenuItemModel menuItemModel: kWOAMenuItemKey_CheckForUpdate
                                                                         title: @"版本"
                                                                     imageName: nil
                                                                 showAccessory: YES];
        WOAMenuItemModel *itemAbout = [WOAMenuItemModel menuItemModel: kWOAMenuItemKey_About
                                                                title: @"关于我们"
                                                            imageName: nil
                                                        showAccessory: YES];
        WOAMenuItemModel *itemDraft = [WOAMenuItemModel menuItemModel: kWOAMenuItemKey_Draft
                                                                title: @"草稿箱"
                                                            imageName: nil
                                                        showAccessory: YES];
        WOAMenuItemModel *itemLogout = [WOAMenuItemModel menuItemModel: kWOAMenuItemKey_Logout
                                                                 title: @"退出登陆"
                                                             imageName: nil
                                                         showAccessory: NO];
        
        WOAMenuItemModel *itemSeperator = [WOAMenuItemModel menuItemModel: kWOAMenuItemKey_Seperator
                                                                    title: @""
                                                                imageName: nil
                                                            showAccessory: NO];
        
        self.itemArray = [NSArray arrayWithObjects: itemCheckForUpdate, itemAbout, itemDraft,
                                                    itemSeperator, itemLogout, nil];
        
    }
    
    return self;
}

#pragma mark - private

#pragma mark - delegte

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame: self.view.frame style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview: _tableView];
    
    [self.tableView reloadData];
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
    return (section == 0) ? self.itemArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *moreFeatureTableViewCellIdentifier = @"moreFeatureTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: moreFeatureTableViewCellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: moreFeatureTableViewCellIdentifier];
    else
    {
        UIView *subview;
        
        do
        {
            subview = [cell.contentView.subviews lastObject];
            
            if (subview)
                [subview removeFromSuperview];
        }
        while (!subview);
    }
    
    WOAMenuItemModel *itemModel = [self.itemArray objectAtIndex: indexPath.row];
    
    cell.textLabel.text = itemModel.title;
    cell.accessoryType = itemModel.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainColor];
    cell.textLabel.highlightedTextColor = [UIColor textHighlightedColor];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    WOAMenuItemModel *itemModel = [self.itemArray objectAtIndex: indexPath.row];
    NSString *itemID = itemModel.itemID;
    
    return (itemID && ![itemID isEqualToString: kWOAMenuItemKey_Seperator]) ? 44 : 20;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    WOAMenuItemModel *itemModel = [self.itemArray objectAtIndex: indexPath.row];
    NSString *itemID = itemModel.itemID;
    
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    if ([itemID isEqualToString: kWOAMenuItemKey_Draft])
    {
        
    }
    else if ([itemID isEqualToString: kWOAMenuItemKey_CheckForUpdate])
    {
        [WOACheckForUpdate checkingUpdateFromAppStore: NO];
    }
    else if ([itemID isEqualToString: kWOAMenuItemKey_About])
    {
        WOAAboutViewController *aboutVC = [[WOAAboutViewController alloc] init];
        
        [self.navigationController pushViewController: aboutVC animated: YES];
    }
    else if ([itemID isEqualToString: kWOAMenuItemKey_Logout])
    {
        WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        WOARequestContent *requestContent = [WOARequestContent contentForLogout];
        
        [appDelegate sendRequest: requestContent
                      onSuccuess:^(WOAResponeContent *responseContent)
         {
             appDelegate.sessionID = nil;
             appDelegate.latestLoginRequestContent = nil;
             
             [appDelegate presentLoginViewController: YES];
             
         }
                       onFailure:^(WOAResponeContent *responseContent)
         {
             NSLog(@"Login fail: %d, HTTPStatus=%d", responseContent.requestResult, responseContent.HTTPStatus);
         }];
    }
}

#pragma mark - public


@end
