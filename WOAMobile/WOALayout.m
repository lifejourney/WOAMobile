//
//  WOALayout.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/8/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@implementation WOALayout

+ (CGRect) rectForNavigationTitleView
{
    return CGRectMake(0, 0, 100, 30);
}

+ (UILabel*) lableForNavigationTitleView: (NSString*)text
{
    UILabel *titleView = [[UILabel alloc] initWithFrame: [WOALayout rectForNavigationTitleView]];
    titleView.textColor = [UIColor navigationItemNormalColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = text;
    
    return titleView;
}

@end
