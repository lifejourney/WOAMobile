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
#import "WOAPacketHelper.h"
#import "WOAWorkflowDetailViewController.h"
#import "VSPopoverController.h"
#import "WOAListViewController.h"


@interface WOAWorkflowTypeListViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, WOAListViewControllerDelegate, VSPopoverControllerDelegate>

@property (nonatomic, strong) UITextField *filterTextField;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) VSPopoverController *filterPopoperVC;

@property (nonatomic, assign) NSInteger selectedCategory;
@property (nonatomic, strong) NSArray *categoryInfoArray;
@property (nonatomic, strong) NSDictionary *tableInfoDictionary;
@property (nonatomic, strong) NSArray *categoryTablesArray;

- (void) onFilterCategoryButtonAction: (id) sender;

- (void) initCategoryAndTables;

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
        [self initCategoryAndTables];
    }
    
    return self;
}

- (void) setSelectedCategory: (NSInteger)value
{
    _selectedCategory = value;
        
    self.filterTextField.text = self.categoryInfoArray[_selectedCategory];
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: @"新建工作"];
    
    UIView *filterView = [[UIView alloc] initWithFrame: CGRectZero];
    filterView.backgroundColor = [UIColor filterViewBgColor];
    [self.view addSubview: filterView];
    
    self.filterTextField = [[UITextField alloc] initWithFrame: CGRectZero];
    _filterTextField.delegate = self;
    _filterTextField.text = @"全部";
    _filterTextField.textAlignment = NSTextAlignmentCenter;
    _filterTextField.borderStyle = UITextBorderStyleRoundedRect;
    _filterTextField.backgroundColor = [UIColor whiteColor];
    _filterTextField.rightViewMode = UITextFieldViewModeAlways;
    _filterTextField.rightView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"DropDownIcon"]];
    [_filterTextField addTarget: self action: @selector(onFilterCategoryButtonAction:) forControlEvents: UIControlEventTouchDown];
    [self.view addSubview: _filterTextField];
    
    self.listView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _listView.dataSource = self;
    _listView.delegate = self;
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: _listView];
    
    CGRect selfRect = self.view.frame;
    CGRect navRect = self.navigationController.navigationBar.frame;
    CGFloat contentTopMargin = self.navigationController.navigationBar.isHidden ? 0 : (navRect.origin.y + navRect.size.height);
    
    CGFloat buttonHeight = 30;
    CGFloat buttonTopMargin = 7;
    CGFloat filterHeight = buttonHeight + buttonTopMargin * 2;
    CGFloat listOriginY = contentTopMargin + filterHeight;
    
    filterView.frame = CGRectMake(0, contentTopMargin, selfRect.size.width, filterHeight);
    _filterTextField.frame = CGRectMake(kWOALayout_DefaultLeftMargin,
                                        contentTopMargin + buttonTopMargin,
                                        selfRect.size.width - kWOALayout_DefaultLeftMargin - kWOALayout_DefaultRightMargin,
                                        buttonHeight);
    _listView.frame = CGRectMake(0, listOriginY, selfRect.size.width, selfRect.size.height - listOriginY);
    
    [self.listView reloadData];
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    NSArray *selectedTables = self.categoryTablesArray[self.selectedCategory];
    
    return [selectedTables count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
    NSArray *selectedTables = self.categoryTablesArray[self.selectedCategory];
    
    cell.textLabel.text = [self.tableInfoDictionary objectForKey: [selectedTables objectAtIndex: indexPath.row]];
    
    cell.textLabel.textColor = [UIColor textNormalColor];
    cell.textLabel.highlightedTextColor = [UIColor textHighlightedColor];
    cell.backgroundColor = ((indexPath.row % 2) == 0) ? [UIColor listDarkBgColor] : [UIColor listLightBgColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    
    
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
    
    NSArray *selectedTables = self.categoryTablesArray[self.selectedCategory];
    NSString *tableID = [selectedTables objectAtIndex: indexPath.row];
    
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent = [WOARequestContent contentForWorkflowTypeDetail: tableID];
    
    [appDelegate sendRequest: requestContent
                  onSuccuess:^(WOAResponeContent *responseContent)
     {
         WOAWorkflowDetailViewController *initiateVC;
         initiateVC = [[WOAWorkflowDetailViewController alloc] initWithWorkflowDetailDictionary: responseContent.bodyDictionary
                                                                               detailActionType: WOAFLowActionType_InitiateWorkflow];
         
         [self.navigationController pushViewController: initiateVC animated: YES];
     }
                   onFailure:^(WOAResponeContent *responseContent)
     {
         NSLog(@"Get workflow typeDetail fail: %lu, HTTPStatus=%ld", responseContent.requestResult, (long)responseContent.HTTPStatus);
     }];
}

#pragma mark - delegate

- (void) onFilterCategoryButtonAction: (id)sender
{
    WOAListViewController *contentVC = [[WOAListViewController alloc] initWithItemArray: _categoryInfoArray
                                                                               delegate: self];
    
    self.filterPopoperVC = [[VSPopoverController alloc] initWithContentViewController: contentVC delegate: self];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *inView = window.rootViewController.view;
    [self.filterPopoperVC presentPopoverFromRect: _filterTextField.frame
                                          inView: inView
                        permittedArrowDirections: VSPopoverArrowDirectionUp
                                        animated: YES];
    
    [contentVC selectRow: _selectedCategory];
}

- (void) listViewControllerClickOnRow: (NSInteger)row
{
    [self.filterPopoperVC dismissPopoverAnimated: YES];
    
    _listView.delegate = nil;
    self.selectedCategory = row;
    _listView.delegate = self;
    
    [_listView reloadData];
}

- (void) popoverControllerDidDismissPopover: (VSPopoverController *)popoverController
{
    self.filterPopoperVC = nil;
}

- (BOOL) textFieldShouldBeginEditing: (UITextField *)textField
{
    return NO;
}

#pragma mark - public

- (void) initCategoryAndTables
{
    self.categoryInfoArray = @[@"全部"];
    self.tableInfoDictionary = nil;
    self.categoryTablesArray = @[@[]];
    self.selectedCategory = 0;
}

#pragma mark - WOAStartWorkflowActionReqeust
- (void) parseResponseContent: (NSDictionary*)content
{
    NSMutableArray *categoryInfoArray = [[NSMutableArray alloc] initWithObjects: @"全部", nil];
    NSMutableDictionary *tableInfoDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *categoryTablesArray = [[NSMutableArray alloc] initWithObjects: @[], nil];
    
    NSArray *itemsCategoryArray = [WOAPacketHelper itemsArrayFromPacketDictionary: content];
    
    NSDictionary *itemCategoryDictionary;
    NSMutableArray *itemsTableArray;
    NSMutableArray *allTablesArray = [[NSMutableArray alloc] init];
    for (NSInteger iCategory = 0; iCategory < [itemsCategoryArray count]; iCategory++)
    {
        itemCategoryDictionary = [itemsCategoryArray objectAtIndex: iCategory];
        
        NSArray *itemsArray = [WOAPacketHelper optionArrayFromDictionary: itemCategoryDictionary];
        
        itemsTableArray = [[NSMutableArray alloc] initWithCapacity: [itemsArray count]];
        for (NSInteger iTable = 0; iTable < [itemsArray count]; iTable++)
        {
            NSDictionary *currentTable = [itemsArray objectAtIndex: iTable];
            NSString *tableID = [WOAPacketHelper tableIDFromTableDictionary: currentTable];
            NSString *tableName = [WOAPacketHelper tableNameFromTableDictionary: currentTable];
            
            [tableInfoDictionary setObject: tableName forKey: tableID];
            [itemsTableArray addObject: tableID];
            
            [allTablesArray addObject: tableID];
        }
        
        [categoryInfoArray addObject: [WOAPacketHelper itemNameFromDictionary: itemCategoryDictionary]];
        [categoryTablesArray addObject: itemsTableArray];
    }
    
    [categoryTablesArray replaceObjectAtIndex: 0 withObject: allTablesArray];
    
    _listView.delegate = nil;
    self.categoryInfoArray = categoryInfoArray;
    self.tableInfoDictionary = tableInfoDictionary;
    self.categoryTablesArray = categoryTablesArray;
    self.selectedCategory = MIN(self.selectedCategory, [self.categoryInfoArray count] - 1);
    _listView.delegate = self;
    [_listView reloadData];
}

- (void) sendRequestByActionType
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent = [WOARequestContent contentForWorkflowTypeList];
    
    [appDelegate sendRequest: requestContent
                  onSuccuess:^(WOAResponeContent *responseContent)
    {
        [self parseResponseContent: responseContent.bodyDictionary];
    }
                   onFailure:^(WOAResponeContent *responseContent)
    {
        NSLog(@"Get workflow typeList fail: %lu, HTTPStatus=%ld", responseContent.requestResult, (long)responseContent.HTTPStatus);
    }];
}

@end
