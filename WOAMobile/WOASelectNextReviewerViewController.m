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
#import "WOAPacketHelper.h"
#import "VSSelectedTableViewCell.h"


@interface WOASelectNextReviewerViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, VSSelectedTableViewCellDelegate>

@property (nonatomic, copy) NSString *workID;
@property (nonatomic, strong) NSArray *groupNameArray;
@property (nonatomic, strong) NSArray *groupItemArray;

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
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"返回"
                                                                          style: UIBarButtonItemStylePlain
                                                                         target: self
                                                                         action: @selector(backAction:)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target: self
                                                                          action: @selector(submitAction:)];
    self.navigationItem.title = @"下一步";
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.tableView = [[UITableView alloc] initWithFrame: self.view.frame style: UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsMultipleSelection = YES;
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

- (void) submitAction: (id)sender
{
    NSMutableArray *selectedAccountArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows)
    {
        NSArray *itemArray = [self.groupItemArray objectAtIndex: indexPath.section];
        NSDictionary *itemDictionary = [itemArray objectAtIndex: indexPath.row];
        
        [selectedAccountArray addObject: [WOAPacketHelper accountIDFromDictionary: itemDictionary]];
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
                                                 delegate: self];
    
    NSArray *itemArray = [self.groupItemArray objectAtIndex: indexPath.section];
    NSDictionary *itemDictionary = [itemArray objectAtIndex: indexPath.row];
    
    cell.contentLabel.text = [WOAPacketHelper accountNameFromDictionary: itemDictionary];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    VSSelectedTableViewCell *cell = (VSSelectedTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
    
    cell.selectButton.selected = YES;
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
    
    if (tableViewCell.isSelected)
    {
        [self.tableView deselectRowAtIndexPath: indexPath animated: NO];
        [self tableView: self.tableView didDeselectRowAtIndexPath: indexPath];
    }
    else
    {
        [self.tableView selectRowAtIndexPath: indexPath animated: NO scrollPosition: UITableViewScrollPositionMiddle];
        [self tableView: self.tableView didSelectRowAtIndexPath: indexPath];
    }
}

#pragma mark - UIAlertView
- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated: YES];
}

@end
