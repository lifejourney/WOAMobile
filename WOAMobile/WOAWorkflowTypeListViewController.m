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


@interface WOAWorkflowTypeListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *selectedCategoryLabel;
@property (nonatomic, strong) UIButton *filterCategoryButton;
@property (nonatomic, strong) UITableView *listView;

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
        
    self.selectedCategoryLabel.text = self.categoryInfoArray[_selectedCategory];
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"新建工作";
    
    self.selectedCategoryLabel = [[UILabel alloc] initWithFrame: self.view.frame];
    _selectedCategoryLabel.text = @"全部";
    [_selectedCategoryLabel setTextAlignment: NSTextAlignmentCenter];
    _selectedCategoryLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.view addSubview: _selectedCategoryLabel];
    
    self.filterCategoryButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [_filterCategoryButton setTitle: @"@" forState: UIControlStateNormal];
    [_filterCategoryButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    //TO-DO
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
    NSArray *selectedTables = self.categoryTablesArray[self.selectedCategory];
    
    return [selectedTables count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
    NSArray *selectedTables = self.categoryTablesArray[self.selectedCategory];
    
    cell.textLabel.text = [self.tableInfoDictionary objectForKey: [selectedTables objectAtIndex: indexPath.row]];
    
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
         NSLog(@"Get workflow typeDetail fail: %d, HTTPStatus=%d", responseContent.requestResult, responseContent.HTTPStatus);
     }];
}

#pragma mark - delegate

- (void) onFilterCategoryButtonAction: (id)sender
{
    
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
    
    self.categoryInfoArray = categoryInfoArray;
    self.tableInfoDictionary = tableInfoDictionary;
    self.categoryTablesArray = categoryTablesArray;
    self.selectedCategory = MIN(self.selectedCategory, [self.categoryInfoArray count] - 1);
}

- (void) sendRequestByActionType
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WOARequestContent *requestContent = [WOARequestContent contentForWorkflowTypeList];
    
    [appDelegate sendRequest: requestContent
                  onSuccuess:^(WOAResponeContent *responseContent)
    {
        [self parseResponseContent: responseContent.bodyDictionary];
        
        [self.listView reloadData];
    }
                   onFailure:^(WOAResponeContent *responseContent)
    {
        NSLog(@"Get workflow typeList fail: %d, HTTPStatus=%d", responseContent.requestResult, responseContent.HTTPStatus);
    }];
}

@end
