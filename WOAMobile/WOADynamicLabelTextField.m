//
//  WOADynamicLabelTextField.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/11/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOADynamicLabelTextField.h"
#import "WOAPacketHelper.h"
#import "VSActionSheetDatePicker.h"
#import "VSActionSheetPickerView.h"
#import "WOALayout.h"


@interface WOADynamicLabelTextField () <UITextFieldDelegate>

//TO-DO: weak? strong?
@property (nonatomic, weak) UIView *popoverShowInView;

@property (nonatomic, assign) WOAExtendTextFieldType extendType;
@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic, strong) NSArray *optionArray;

@end

@implementation WOADynamicLabelTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (WOAExtendTextFieldType) extendTypeFromString: (NSString*)typeString
{
    WOAExtendTextFieldType extendType = WOAExtendTextFieldType_Normal;
    
    if (typeString)
    {
        NSString *lowerCaseTypeString = [typeString lowercaseString];
        
        if ([lowerCaseTypeString isEqualToString: @"text"])
            extendType = WOAExtendTextFieldType_Normal;
        else if ([lowerCaseTypeString isEqualToString: @"int"])
            extendType = WOAExtendTextFieldType_IntString;
        else if ([lowerCaseTypeString isEqualToString: @"combobox"])
            extendType = WOAExtendTextFieldType_PickerView;
        else if ([lowerCaseTypeString isEqualToString: @"dateTime"])
            extendType = WOAExtendTextFieldType_DateTimePicker;
        else if ([lowerCaseTypeString isEqualToString: @"date"])
            extendType = WOAExtendTextFieldType_DatePicker;
        else if ([lowerCaseTypeString isEqualToString: @"time"])
            extendType = WOAExtendTextFieldType_TimePicker;
    }
    
    return extendType;
}

- (instancetype) initWithFrame: (CGRect)frame
             popoverShowInView: (UIView*)popoverShowInView
                       section: (NSInteger)section
                           row: (NSInteger)row
                     itemModel: (NSDictionary*)itemModel
{
    if (self = [self initWithFrame: frame])
    {
        self.popoverShowInView = popoverShowInView;
        self.section = section;
        self.row = row;
        
        NSString *typeString = [WOAPacketHelper itemTypeFromDictionary: itemModel];
        NSString *labelText = [WOAPacketHelper itemNameFromDictionary: itemModel];
        BOOL isWritable = [WOAPacketHelper itemWritableFromDictionary: itemModel];
        
        self.defaultValue = [WOAPacketHelper itemValueFromDictionary: itemModel];
        self.extendType = [self extendTypeFromString: typeString];
        if (self.extendType == WOAExtendTextFieldType_PickerView)
        {
            NSArray *optionArray = [WOAPacketHelper optionArrayFromDictionary: itemModel];
            
            self.optionArray = [optionArray sortedArrayUsingSelector: @selector(compare:)];
        }
        else
        {
            self.optionArray = nil;
        }
        self.label = [[UILabel alloc] initWithFrame: CGRectZero];
        _label.text = labelText;
        _label.textAlignment = NSTextAlignmentLeft;
        [self addSubview: _label];
        
        self.textField = [[UITextField alloc] initWithFrame: CGRectZero];
        _textField.text = self.defaultValue;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.userInteractionEnabled = isWritable;
        //TO-DO
        //_textField.rightView = ;
        
        //readonly
        SEL clickSelector;
        switch (_extendType)
        {
            case WOAExtendTextFieldType_PickerView:
                clickSelector = @selector(showPickerView:);
                break;
                
            case WOAExtendTextFieldType_DateTimePicker:
                clickSelector = @selector(showDateTimePicker:);
                break;
                
            case WOAExtendTextFieldType_DatePicker:
                clickSelector = @selector(showDatePicker:);
                break;
                
            case WOAExtendTextFieldType_TimePicker:
                clickSelector = @selector(showTimePicker:);
                break;
                
            default:
                clickSelector = nil;
                break;
        }
        if (clickSelector != nil)
        {
            [_textField addTarget: self action: clickSelector forControlEvents: UIControlEventTouchDown];
        }
        [self addSubview: _textField];
        
        
        //set frames
        CGFloat originY = frame.origin.x + kWOALayout_ItemTopMargin;
        CGFloat sizeHeight = kWOALayout_ItemCommonHeight;
        CGFloat labelOriginX = frame.origin.x;
        CGFloat labelWidth = kWOALayout_ItemLabelWidth;
        CGFloat textOriginX = labelOriginX + labelWidth + kWOALayout_ItemLabelTextField_Gap;
        CGFloat textWidth = frame.size.width - textOriginX;
        CGRect labelRect = CGRectMake(labelOriginX, originY, labelWidth, sizeHeight);
        CGRect textRect = CGRectMake(textOriginX, originY, textWidth, sizeHeight);
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, originY + sizeHeight);
        
        [self setFrame: selfRect];
        [_label setFrame: labelRect];
        [_textField setFrame: textRect];
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void) showPickerView: (id)sender
{
    VSActionSheetPickerView *actionSheetPickerView = [[VSActionSheetPickerView alloc] init];
    
    [actionSheetPickerView showSingleColumnPickerViewInView: self.popoverShowInView
                                                  dataModel: self.optionArray
                                            selectedHandler: ^(NSInteger row)
    {
        self.textField.text = [self.optionArray objectAtIndex: row];
    }
                                           cancelledHandler: ^
    {
    }];
}

- (void) showActionSheetDatePicker: (id)sender datePickerMode: (UIDatePickerMode)datePickerMode
{
    VSActionSheetDatePicker *actionSheetDatePicker = [[VSActionSheetDatePicker alloc] init];
    
    NSString *dateFormatString;
    switch (self.extendType)
    {
        case WOAExtendTextFieldType_DateTimePicker:
            dateFormatString = kWOADefaultDateTimeFormat;
            break;
            
        case WOAExtendTextFieldType_DatePicker:
            dateFormatString = kWOADefaultDateFormat;
            break;
            
        case WOAExtendTextFieldType_TimePicker:
            dateFormatString = kWOADefaultTimeFormat;
            break;
            
        default:
            dateFormatString = nil;
            break;
    }
    
    [actionSheetDatePicker showInView: self.popoverShowInView
                       datePickerMode: datePickerMode
                    currentDateString: self.textField.text
                     dateFormatString: dateFormatString
                      selectedHandler: ^(NSString *selectedDateString)
    {
        self.textField.text = selectedDateString;
    }
                     cancelledHandler: nil];
}

- (void) showDatePicker: (id)sender
{
    [self showActionSheetDatePicker: sender datePickerMode: UIDatePickerModeDate];
}

- (void) showTimePicker: (id)sender
{
    [self showActionSheetDatePicker: sender datePickerMode: UIDatePickerModeTime];
}

- (void) showDateTimePicker: (id)sender
{
    [self showActionSheetDatePicker: sender datePickerMode: UIDatePickerModeDateAndTime];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return (_extendType == WOAExtendTextFieldType_Normal ||
            _extendType == WOAExtendTextFieldType_IntString);
}

@end





