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
    WOAExtendTextFieldType_IntString,
    WOAExtendTextFieldType_DatePicker,
    WOAExtendTextFieldType_TimePicker,
    WOAExtendTextFieldType_DateTimePicker,
    WOAExtendTextFieldType_PickerView,
    WOAExtendTextFieldType_AttachFile,
    WOAExtendTextFieldType_TextList,
    WOAExtendTextFieldType_CheckUserList,
};

@protocol WOADynamicLabelTextFieldDelegate <NSObject>

@optional
- (void) textFieldTryBeginEditing: (UITextField *)textField allowEditing: (BOOL)allowEditing;
- (void) textFieldDidBecameFirstResponder: (UITextField *)textField;

@end

@interface WOADynamicLabelTextField : UIView

@property (nonatomic, weak) id<WOADynamicLabelTextFieldDelegate> delegate;
@property (nonatomic, strong) UINavigationController *hostNavigation;

@property (nonatomic, copy) NSString *imageFullFileName;
@property (nonatomic, copy) NSString *imageFileNameInServer;

- (instancetype) initWithFrame: (CGRect)frame
             popoverShowInView: (UIView*)popoverShowInView
                       section: (NSInteger)section
                           row: (NSInteger)row
                    isEditable: (BOOL)isEditable
                     itemModel: (NSDictionary*)itemModel;

- (NSDictionary*) toDataModelWithIndexPath;

- (void) selectDefaultValueFromPickerView;

@end
