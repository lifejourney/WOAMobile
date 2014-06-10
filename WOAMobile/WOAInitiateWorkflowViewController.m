//
//  WOAInitiateWorkflowViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAInitiateWorkflowViewController.h"
#import "WOAAppDelegate.h"
#import "WOALayout.h"


#define kItemLabel_Width (80)
#define kItemLabel_LeftMargin (2)
#define kItemLabel_RightMargin (2)
#define kItemText_RightMargin (10)
#define kItemCommon_Height (30)
#define kItemCommon_TopMargin (10)


@interface WOAInitiateWorkflowViewController ()

@property (nonatomic, copy) NSString *workID;
@property (nonatomic, copy) NSString *tableID;
@property (nonatomic, strong) UIView *dynamicViewsContainer;

@end

@implementation WOAInitiateWorkflowViewController

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

- (instancetype) initWithWorkflowDetailDictionary: (NSDictionary*)dict
{
    if (self = [self init])
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendRequestForWorkflowTypeList
{
    
}

@end
