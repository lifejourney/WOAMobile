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


@interface WOASelectNextReviewerViewController ()

@property (nonatomic, copy) NSString *workID;

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
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
