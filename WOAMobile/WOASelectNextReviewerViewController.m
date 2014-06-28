//
//  WOASelectNextReviewerViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOASelectNextReviewerViewController.h"
#import "WOAAppDelegate.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "WOAPacketHelper.h"
#import "VSSelectedTableViewCell.h"


@interface WOASelectNextReviewerViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, VSSelectedTableViewCellDelegate>

@property (nonatomic, copy) NSString *workID;
@property (nonatomic, strong) NSArray *groupNameArray;
@property (nonatomic, strong) NSArray *groupItemArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WOASelectNextReviewerViewController

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

- (instancetype) initWithWorkID: (NSString*)workID accountsGroupArray: (NSArray*)accountGroupsArray
{
    if (self = [self init])
    {
        self.workID = workID;
        
        NSMutableArray *groupNameArray = [[NSMutableArray alloc] init];
        NSMutableArray *groupItemArray = [[NSMutableArray alloc] init];
        self.statusArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *groupDictionary in accountGroupsArray)
        {
            NSArray *keyArray = [groupDictionary allKeys];
            if ([keyArray count] <= 0)
                continue;
            
            NSString *key = [keyArray firstObject];
            NSArray *valueArray = [groupDictionary valueForKey: key];
            if ([valueArray count] <= 0)
                continue;
            
            [groupNameArray addObject: key];
            [groupItemArray addObject: valueArray];
            
            NSMutableArray *selectedArray = [[NSMutableArray alloc] initWithCapacity: [valueArray count]];
            for (NSUInteger i = 0; i < [valueArray count]; i++)
            {
                [selectedArray addObject: [NSNumber numberWithBool: NO]];
            }
            [_statusArray addObject: selectedArray];
        }
        
        self.groupNameArray = groupNameArray;
        self.groupItemArray = groupItemArray;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target: self
                                                                          action: @selector(submitAction:)];
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: @"下一步"];
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.tableView = [[UITableView alloc] initWithFrame: self.view.frame style: UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview: _tableView];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backAction: (id)sender
{
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (BOOL) statusFromIndexPath: (NSIndexPath*)indexPath
{
    NSArray *items = [_statusArray objectAtIndex: indexPath.section];
    NSNumber *status = [items objectAtIndex: indexPath.row];
    
    return [status boolValue];
}

- (void) setStatus: (BOOL)status forIndexPath: (NSIndexPath*)indexPath
{
    NSMutableArray *items = [_statusArray objectAtIndex: indexPath.section];
    
    [items replaceObjectAtIndex: indexPath.row withObject: [NSNumber numberWithBool: status]];
}

- (NSArray*) indexPathsForSelectedRows
{
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    
    for (NSUInteger section = 0; section < [_statusArray count]; section++)
    {
        NSArray *items = [_statusArray objectAtIndex: section];
        
        NSNumber *status;
        for (NSUInteger row = 0; row < [items count]; row++)
        {
            status = [items objectAtIndex: row];
            
            if ([status boolValue])
                [selectedArray addObject: [NSIndexPath indexPathForRow: row inSection: section]];
        }
    }
    
    return selectedArray;
}

- (void) submitAction: (id)sender
{
    NSMutableArray *selectedAccountArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in [self indexPathsForSelectedRows])
    {
        NSArray *itemArray = [self.groupItemArray objectAtIndex: indexPath.section];
        NSDictionary *itemDictionary = [itemArray objectAtIndex: indexPath.row];
        
        [selectedAccountArray addObject: [WOAPacketHelper accountIDFromDictionary: itemDictionary]];
    }
    
    if ([selectedAccountArray count] == 0)
    {
        //TO-DO
    }
    
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent = [WOARequestContent contentForSelectNextReviewer: self.workID
                                                                           accountArray: selectedAccountArray];
    
    [appDelegate sendRequest: requestContent
                  onSuccuess:^(WOAResponeContent *responseContent)
     {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"已转至下一步"
                                                             message: nil
                                                            delegate: self
                                                   cancelButtonTitle: @"确定"
                                                   otherButtonTitles: nil, nil];
         
         [alertView show];
     }
                   onFailure:^(WOAResponeContent *responseContent)
     {
         NSLog(@"Select next reviewer [Initiate workflow] fail: %d, HTTPStatus=%d", responseContent.requestResult, responseContent.HTTPStatus);
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupItemArray ? [self.groupItemArray count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = [self.groupItemArray objectAtIndex: section];
    
    return itemArray ? [itemArray count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString*) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    return [self.groupNameArray objectAtIndex: section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSSelectedTableViewCell *cell;
    cell = [[VSSelectedTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: nil
                                                  section: indexPath.section
                                                      row: indexPath.row
                                            checkedButton: [self statusFromIndexPath: indexPath]
                                                 delegate: self];
    
    NSArray *itemArray = [self.groupItemArray objectAtIndex: indexPath.section];
    NSDictionary *itemDictionary = [itemArray objectAtIndex: indexPath.row];
    
    cell.contentLabel.text = [WOAPacketHelper accountNameFromDictionary: itemDictionary];
    
    cell.contentLabel.textColor = [UIColor textNormalColor];
    cell.contentLabel.highlightedTextColor = [UIColor textHighlightedColor];
    cell.backgroundColor = [UIColor listLightBgColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    BOOL status = [self statusFromIndexPath: indexPath];
    [self setStatus: !status forIndexPath: indexPath];
    
    VSSelectedTableViewCell *cell = (VSSelectedTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
    
    [cell.selectButton setSelected: !status];
}

- (void)tableView: (UITableView *)tableView didDeselectRowAtIndexPath: (NSIndexPath *)indexPath
{
    VSSelectedTableViewCell *cell = (VSSelectedTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
    
    cell.selectButton.selected = NO;
}

#pragma mark - VSSelectedTableViewCellDelegate

- (void) actionForTableViewCell: (VSSelectedTableViewCell *)tableViewCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: tableViewCell.row inSection: tableViewCell.section];
    
    [self tableView: _tableView didSelectRowAtIndexPath: indexPath];
}

#pragma mark - UIAlertView
- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated: YES];
}

@end
