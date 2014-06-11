//
//  WOADynamicLabelTextField.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/11/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, WOAExtendTextFieldType)
{
    WOAExtendTextFieldType_Normal = 0,
    WOAExtendTextFieldType_DatePicker,
    WOAExtendTextFieldType_TimePicker,
    WOAExtendTextFieldType_DateTimePicker,
    WOAExtendTextFieldType_PickerView,
};

@interface WOADynamicLabelTextField : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) NSObject<UITextFieldDelegate>*  textFieldDelegate;

@property (nonatomic, assign) NSInteger *section;
@property (nonatomic, assign) NSInteger *row;
@property (nonatomic, assign) WOAExtendTextFieldType extendType;
@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic, strong) NSArray *optionArray;

- (instancetype) initWithFrame: (CGRect)frame
                       section: (NSInteger)section
                           row: (NSInteger)row
                     itemModel: (NSDictionary*)itemModel
             textFieldDelegate: (NSObject<UITextFieldDelegate>*)textFieldDelegate;

@end
