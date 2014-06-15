//
//  WOAWorkflowFormListViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAWorkflowFormListViewController.h"
#import "WOAAppDelegate.h"
#import "WOALayout.h"
#import "WOAPacketHelper.h"


@interface WOAWorkflowFormListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation WOAWorkflowFormListViewController

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
    
    NSString *navigationTitle = @"";
    switch (self.actionType)
    {
        case WOAFLowActionType_GetTodoWorkflowList:
            navigationTitle = @"代办事项";
            break;
            
        case WOAFLowActionType_GetHistoryWorkflowList:
            navigationTitle = @"查询";
            break;
        case WOAFLowActionType_GetDraftWorkflowList:
            navigationTitle = @"草稿箱";
            break;
            
        default:
            break;
    }
    
    self.navigationItem.title = navigationTitle;
    
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
    return (section == 0) ? self.itemsArray.count : 0;
}

- (NSString*) itemDetailsFromDictionary: (NSDictionary*)itemDictionary
{
    //TO-DO
    return [WOAPacketHelper createTimeFromDictionary: itemDictionary];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: nil];
    
    NSDictionary *itemDictionary = [self.itemsArray objectAtIndex: indexPath.row];
    
    cell.textLabel.text = [WOAPacketHelper formTitleFromDictionary: itemDictionary];
    cell.detailTextLabel.text = [self itemDetailsFromDictionary: itemDictionary];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 44;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    NSDictionary *itemDictionary = [self.itemsArray objectAtIndex: indexPath.row];
    NSString *workID = [WOAPacketHelper workIDFromDictionary: itemDictionary];
    
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent;
    
    if (_actionType == WOAFLowActionType_GetTodoWorkflowList)
        requestContent = [WOARequestContent contentForWorkflowFormDetail: workID];
    else if (_actionType == WOAFLowActionType_GetHistoryWorkflowList)
        requestContent = [WOARequestContent contentForWorkflowViewDetail: workID];
    else if (_actionType == WOAFLowActionType_GetDraftWorkflowList)
        return;//TO-DO: requestContent = [WOARequestContent contentForDraftWorkflowList];
    else
        return;
    
    [appDelegate sendRequest: requestContent
                  onSuccuess:^(WOAResponeContent *responseContent)
     {
//         WOAInitiateWorkflowViewController *initiateVC = [[WOAInitiateWorkflowViewController alloc] initWithWorkflowDetailDictionary: responseContent.bodyDictionary];
//         
//         [self.navigationController pushViewController: initiateVC animated: YES];
     }
                   onFailure:^(WOAResponeContent *responseContent)
     {
         NSLog(@"Get [actionType: %d] workflow detail fail: %d, HTTPStatus=%d", self.actionType, responseContent.requestResult, responseContent.HTTPStatus);
     }];
}


#pragma mark - WOAStartWorkflowActionReqeust
- (void) parseResponseContent: (NSDictionary*)content
{
    NSArray *itemsArray = [WOAPacketHelper itemsArrayFromPacketDictionary: content];
    
    NSSortDescriptor *createTimeKey = [[NSSortDescriptor alloc] initWithKey: kWOAKey_CreateTime ascending: NO];
    //TO-DO
    self.itemsArray = [itemsArray sortedArrayUsingDescriptors: [NSArray arrayWithObjects: createTimeKey, nil]];
}

- (void) sendRequestByActionType
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent;
    
    if (_actionType == WOAFLowActionType_GetTodoWorkflowList)
        requestContent = [WOARequestContent contentForTodoWorkflowList];
    else if (_actionType == WOAFLowActionType_GetHistoryWorkflowList)
        requestContent = [WOARequestContent contentForHistoryWorkflowList];
    else if (_actionType == WOAFLowActionType_GetDraftWorkflowList)
        requestContent = [WOARequestContent contentForDraftWorkflowList];
    else
        return;
    
    [appDelegate sendRequest: requestContent
                  onSuccuess:^(WOAResponeContent *responseContent)
     {
         [self parseResponseContent: responseContent.bodyDictionary];
         
         [self.tableView reloadData];
     }
                   onFailure:^(WOAResponeContent *responseContent)
     {
         NSLog(@"Get workflow typeList fail: %d, HTTPStatus=%d", responseContent.requestResult, responseContent.HTTPStatus);
     }];
}

@end
