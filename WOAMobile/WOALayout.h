//
//  WOALayout.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/8/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWOALayout_DefaultLeftMargin 10
#define kWOALayout_DefaultRightMargin 10
#define kWOALayout_DefaultTopMargin 10
#define kWOALayout_DefaultBottomMargin 10

#define kWOALayout_ItemCommonHeight (30)
#define kWOALayout_ItemLabelWidth (80)
#define kWOALayout_ItemTopMargin (4)
#define kWOALayout_ItemLabelTextField_Gap (2)

#define kWOADefaultDateFormat @"YYYY-MM-dd"
#define kWOADefaultTimeFormat @"hh:mm"
#define kWOADefaultDateTimeFormat @"YYYY-MM-dd hh:mm"

@interface WOALayout : NSObject

+ (CGRect) rectForNavigationTitleView;
+ (UILabel*) lableForNavigationTitleView: (NSString*)text;

@end
