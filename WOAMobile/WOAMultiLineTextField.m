//
//  WOAMultiLineTextField.m
//  WOAMobile
//
//  Created by steven.zhuang on 8/27/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMultiLineTextField.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOAMultiLineTextField () <UITextFieldDelegate>

@end

@implementation WOAMultiLineTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype) initWithFrame: (CGRect)frame
                    textsArray: (NSArray*)textsArray;
{
    if (self = [self initWithFrame: frame])
    {
        self.textsArray = textsArray;
        
        CGFloat originY = 0;
        
        CGFloat oneLineHeight = kWOALayout_ItemTopMargin + kWOALayout_ItemCommonHeight;
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, oneLineHeight * [textsArray count]);
        [self setFrame: selfRect];
        
        for (NSInteger index = 0; index < [textsArray count]; index++)
        {
            UITextField *oneLineField = [[UITextField alloc] initWithFrame: CGRectZero];
            oneLineField.font = [oneLineField.font fontWithSize: 12.0f];
            oneLineField.delegate = self;
            oneLineField.text = [textsArray objectAtIndex: index];
            oneLineField.textAlignment = NSTextAlignmentLeft;
            oneLineField.borderStyle = UITextBorderStyleNone;
            oneLineField.userInteractionEnabled = NO;
            oneLineField.keyboardType = UIKeyboardTypeDefault;
            oneLineField.rightViewMode = UITextFieldViewModeNever;
            
            //[self addSubview: oneLineField];
            
            //set frames
            originY += kWOALayout_ItemTopMargin;
            CGFloat sizeHeight = kWOALayout_ItemCommonHeight;
            CGRect textRect = CGRectMake(frame.origin.x, originY, frame.size.width, sizeHeight);
            
            [oneLineField setFrame: textRect];
            
            originY += sizeHeight;
        }
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
}

@end
