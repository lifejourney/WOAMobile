//
//  WOAMoreFeatureViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMoreFeatureViewController.h"
#import "WOAMenuItemModel.h"
#import "WOACheckForUpdate.h"


#define kWOAMenuItemKey_Draft @"draft"
#define kWOAMenuItemKey_CheckForUpdate @"update"
#define kWOAMenuItemKey_About @"about"


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
        WOAMenuItemModel *itemDraft = [WOAMenuItemModel menuItemModel: kWOAMenuItemKey_Draft
                                                                title: @"草稿箱"
                                                            imageName: nil];
        WOAMenuItemModel *itemAbout = [WOAMenuItemModel menuItemModel: kWOAMenuItemKey_About
                                                                title: @"关于我们"
                                                            imageName: nil];
        WOAMenuItemModel *itemCheckForUpdate = [WOAMenuItemModel menuItemModel: kWOAMenuItemKey_CheckForUpdate
                                                                         title: @"版本更新"
                                                                     imageName: nil];
        
        self.itemArray = [NSArray arrayWithObjects: itemDraft, itemCheckForUpdate, itemAbout, nil];
        
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
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 44;
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
    }
}

#pragma mark - public


@end
