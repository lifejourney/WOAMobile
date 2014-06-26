//
//  WOAWorkflowFormListViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAWorkflowFormListViewController.h"
#import "WOAAppDelegate.h"
#import "WOAWorkflowDetailViewController.h"
#import "WOALayout.h"
#import "WOAPacketHelper.h"
#import "NSString+PinyinInitial.h"


@interface WOAWorkflowFormListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) NSArray *filteredArray;

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
    
    UILabel *titleView = [WOALayout lableForNavigationTitleView: @""];
    
    switch (self.listActionType)
    {
        case WOAFLowActionType_GetTodoWorkflowList:
            titleView.text = @"代办事项";
            break;
            
        case WOAFLowActionType_GetHistoryWorkflowList:
            titleView.text = @"查询";
            break;
        case WOAFLowActionType_GetDraftWorkflowList:
            titleView.text = @"草稿箱";
            break;
            
        default:
            break;
    }
    
    self.navigationItem.titleView = titleView;
    
    //TO-DO
    CGFloat contentOriginY = [self.topLayoutGuide length];
    contentOriginY += self.navigationController.navigationBar.frame.origin.y;
    if (!self.navigationController.isNavigationBarHidden)
        contentOriginY += self.navigationController.navigationBar.frame.size.height;
    
    
    CGFloat searchBarHeight = 44;
    CGRect selfRect = self.view.frame;
    CGRect searchBarRect = CGRectMake(selfRect.origin.x,
                                      selfRect.origin.y + contentOriginY,
                                      selfRect.size.width,
                                      searchBarHeight);
    CGRect tableViewRect = CGRectMake(selfRect.origin.x,
                                      selfRect.origin.y + contentOriginY + searchBarHeight,
                                      selfRect.size.width,
                                      selfRect.size.height - contentOriginY - searchBarHeight);
    
    self.searchBar = [[UISearchBar alloc] initWithFrame: searchBarRect];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    [self.view addSubview: _searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame: tableViewRect style: UITableViewStylePlain];
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
    return (section == 0) ? self.filteredArray.count : 0;
}

- (NSString*) itemDetailsFromDictionary: (NSDictionary*)itemDictionary
{
    //TO-DO
    return [WOAPacketHelper createTimeFromDictionary: itemDictionary];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: nil];
    
    NSDictionary *itemDictionary = [self.filteredArray objectAtIndex: indexPath.row];
    
    cell.textLabel.text = [WOAPacketHelper formTitleFromDictionary: itemDictionary];
    cell.detailTextLabel.text = [self itemDetailsFromDictionary: itemDictionary];
    //TO-DO: backgroundView?
    cell.backgroundColor = ((indexPath.row % 2) == 0) ? [UIColor listHeavyColor] : [UIColor listLightColor];
    
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
    
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }
    
    NSDictionary *itemDictionary = [self.filteredArray objectAtIndex: indexPath.row];
    NSString *workID = [WOAPacketHelper workIDFromDictionary: itemDictionary];
    
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent;
    
    if (_listActionType == WOAFLowActionType_GetTodoWorkflowList)
        requestContent = [WOARequestContent contentForWorkflowFormDetail: workID];
    else if (_listActionType == WOAFLowActionType_GetHistoryWorkflowList)
        requestContent = [WOARequestContent contentForWorkflowViewDetail: workID];
    else if (_listActionType == WOAFLowActionType_GetDraftWorkflowList)
        return;//TO-DO: requestContent = [WOARequestContent contentForDraftWorkflowList];
    else
        return;
    
    [appDelegate sendRequest: requestContent
                  onSuccuess:^(WOAResponeContent *responseContent)
     {
         WOAFLowActionType detailActionType;
         if (_listActionType == WOAFLowActionType_GetTodoWorkflowList)
             detailActionType = WOAFLowActionType_GetWorkflowFormDetail;
         else if (_listActionType == WOAFLowActionType_GetHistoryWorkflowList)
             detailActionType = WOAFLowActionType_GetWorkflowViewDetail;
         else if (_listActionType == WOAFLowActionType_GetDraftWorkflowList)
             return;//TO-DO: detailActionType = ;
         else
             return;
         
         WOAWorkflowDetailViewController *detailVC;
         detailVC = [[WOAWorkflowDetailViewController alloc] initWithWorkflowDetailDictionary: responseContent.bodyDictionary
                                                                             detailActionType: detailActionType];
         
         [self.navigationController pushViewController: detailVC animated: YES];
     }
                   onFailure:^(WOAResponeContent *responseContent)
     {
         NSLog(@"Get [actionType: %d] workflow detail fail: %d, HTTPStatus=%d", self.listActionType, responseContent.requestResult, responseContent.HTTPStatus);
     }];
}

#pragma mark - UISearchBarDelegate
- (void) searchBar: (UISearchBar *)searchBar textDidChange: (NSString *)searchText
{
    if (!searchText || [searchText length] == 0)
    {
        //TO-DO, could be cancelld? by block.
        _tableView.delegate = nil;
        self.filteredArray = self.itemsArray;
        _tableView.delegate = self;
    }
    else
    {
        NSString *upperCaseText = [searchText uppercaseString];
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock: ^BOOL(id evaluatedObject, NSDictionary *bindings)
        {
            NSDictionary *itemDictionary = evaluatedObject;
            NSString *pinyinInitial = [itemDictionary valueForKey: kWOAKey_PinyinInitial];
            NSRange foundRange = [pinyinInitial rangeOfString: upperCaseText];
            if (foundRange.length > 0)
                return YES;
            
            NSString *formTitle = [WOAPacketHelper formTitleFromDictionary: itemDictionary];
            foundRange = [formTitle rangeOfString: searchText];
            if (foundRange.length > 0)
                return YES;
            
            return NO;
        }];
        
        //TO-DO, could be cancelld? by block.
        _tableView.delegate = nil;
        _filteredArray = [self.itemsArray filteredArrayUsingPredicate: predicate];
        _tableView.delegate = self;
    }
    
    [_tableView reloadData];
}

- (void) searchBarCancelButtonClicked: (UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self searchBar: searchBar textDidChange: searchBar.text];
    
    if ([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
}

#pragma mark - WOAStartWorkflowActionReqeust
- (void) parseResponseContent: (NSDictionary*)content
{
    NSArray *itemsArray = [WOAPacketHelper itemsArrayFromPacketDictionary: content];
    
    //TO-DO, key
    NSSortDescriptor *createTimeKey = [[NSSortDescriptor alloc] initWithKey: kWOAKey_CreateTime ascending: NO];
    itemsArray = [itemsArray sortedArrayUsingDescriptors: [NSArray arrayWithObjects: createTimeKey, nil]];
    
    NSMutableArray *withInitialArray = [[NSMutableArray alloc] initWithCapacity: [itemsArray count]];
    for (NSUInteger i = 0; i < [itemsArray count]; i++)
    {
        NSMutableDictionary *itemDictionary = [[NSMutableDictionary alloc] initWithDictionary: [itemsArray objectAtIndex: i]];
        NSString *formTitle = [WOAPacketHelper formTitleFromDictionary: itemDictionary];
        [itemDictionary setValue: [formTitle pinyinInitials] forKey: kWOAKey_PinyinInitial];
        
        [withInitialArray addObject: itemDictionary];
    }
    self.itemsArray = withInitialArray;
    
    self.filteredArray = self.itemsArray;
}

- (void) sendRequestByActionType
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent;
    
    if (_listActionType == WOAFLowActionType_GetTodoWorkflowList)
        requestContent = [WOARequestContent contentForTodoWorkflowList];
    else if (_listActionType == WOAFLowActionType_GetHistoryWorkflowList)
        requestContent = [WOARequestContent contentForHistoryWorkflowList];
    else if (_listActionType == WOAFLowActionType_GetDraftWorkflowList)
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
