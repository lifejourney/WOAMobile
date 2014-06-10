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

#define kWOALayout_DefaultBottomMargin 10

#define kWOADefaultDateFormat @"YYYY-MM-dd"
#define kWOADefaultTimeFormat @"hh:mm"
#define kWOADefaultDateTimeFormat @"YYYY-MM-dd hh:mm"

typedef NS_OPTIONS(NSInteger, WOAExtendTag)
{
    WOAExtendTag_Default = 0,
    WOAExtendTag_IsReadOnly = 1 << 0,
    WOAExtendTag_IsDatePicker = 1 << 1,
    WOAExtendTag_IsTimePicker = 1 << 2,
};

@interface WOALayout : NSObject

@end
