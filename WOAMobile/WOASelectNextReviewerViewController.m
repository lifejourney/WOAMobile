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


@interface WOASelectNextReviewerViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *workID;
@property (nonatomic, strong) NSArray *accountGroupsArray;
@property (nonatomic, strong) NSMutableArray *selectedAccountArray;

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
        self.accountGroupsArray = accountGroupsArray;
        
        self.selectedAccountArray = [[NSMutableArray alloc] init];
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
    [_tableView setEditing: YES];
    _tableView.allowsMultipleSelection = YES;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
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
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent = [WOARequestContent contentForSelectNextReviewer:self.workID
                                                                           accountArray: self.selectedAccountArray];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    return [NSString stringWithFormat: @"%d", section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: nil];
//    NSArray *selectedTables = self.categoryTablesArray[self.selectedCategory];
//    
//    cell.textLabel.text = [self.tableInfoDictionary objectForKey: [selectedTables objectAtIndex: indexPath.row]];
//    cell.textLabel.text = [NSString stringWithFormat: @"%d: %d", indexPath.section, indexPath.row];
    
//    cell.detailTextLabel.text = @"detail";
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UIAlertView
- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated: YES];
}

@end
