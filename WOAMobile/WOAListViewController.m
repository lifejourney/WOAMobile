//
//  WOAListViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAListViewController.h"
#import "UIColor+AppTheme.h"


@interface WOAListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) NSObject<WOAListViewControllerDelegate> *delegate;
@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WOAListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id) initWithItemArray: (NSArray*)itemArray delegate: (NSObject<WOAListViewControllerDelegate>*)delegate
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        self.itemArray = itemArray;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = self.view.frame;
    //TO-DO
    rect.origin.x += 10;
    rect.size.width -= 30;
    
    self.tableView = [[UITableView alloc] initWithFrame: rect style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview: _tableView];
    
    [self.tableView reloadData];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (CGSize) preferredContentSize;
{
    //TO-DO
    return CGSizeMake (310, 30 * [_itemArray count]);
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
    UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
    
    cell.textLabel.text = [_itemArray objectAtIndex: indexPath.row];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 30;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    if (_delegate && [_delegate respondsToSelector: @selector(listViewControllerClickOnRow:)])
    {
        [_delegate listViewControllerClickOnRow: indexPath.row];
    }
}

@end
