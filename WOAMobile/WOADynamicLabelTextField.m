//
//  WOADynamicLabelTextField.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/11/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOADynamicLabelTextField.h"

#define kItemLabel_Width (80)
#define kItemLabel_LeftMargin (2)
#define kItemLabel_RightMargin (2)
#define kItemText_RightMargin (10)
#define kItemCommon_Height (30)
#define kItemCommon_TopMargin (10)

@interface WOADynamicLabelTextField ()


@end

@implementation WOADynamicLabelTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype) initWithFrame: (CGRect)frame
                       section: (NSInteger)section
                           row: (NSInteger)row
                     itemModel: (NSDictionary*)itemModel
             textFieldDelegate: (NSObject<UITextFieldDelegate>*)textFieldDelegate
{
    if (self = [self initWithFrame: frame])
    {
        
    }
    
    return self;
}

- (void) layoutSubviews
{
    
}

@end
