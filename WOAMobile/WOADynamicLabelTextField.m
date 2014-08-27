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
#import "UIColor+AppTheme.h"
#import "NSFileManager+AppFolder.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface WOADynamicLabelTextField () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) BOOL isWritable;

//Attachment
@property (nonatomic, copy) NSString *imageFileName;
@property (nonatomic, assign) long long imageFileSize;

//TO-DO: weak? strong?
@property (nonatomic, weak) UIView *popoverShowInView;

@property (nonatomic, assign) WOAExtendTextFieldType extendType;
@property (nonatomic, strong) NSArray *optionArray;

@property (nonatomic, strong) VSActionSheetDatePicker *actionSheetDatePicker;
@property (nonatomic, strong) VSActionSheetPickerView *actionSheetPickerView;

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
        else if ([lowerCaseTypeString isEqualToString: @"date"])
            extendType = WOAExtendTextFieldType_DatePicker;
        else if ([lowerCaseTypeString isEqualToString: @"time"])
            extendType = WOAExtendTextFieldType_TimePicker;
        else if ([lowerCaseTypeString isEqualToString: @"datetime"])
            extendType = WOAExtendTextFieldType_DateTimePicker;
        else if ([lowerCaseTypeString isEqualToString: @"combobox"])
            extendType = WOAExtendTextFieldType_PickerView;
        else if ([lowerCaseTypeString isEqualToString: @"attfile"])
            extendType = WOAExtendTextFieldType_AttachFile;
        else if ([lowerCaseTypeString isEqualToString: @"textlist"])
            extendType = WOAExtendTextFieldType_TextList;
        else if ([lowerCaseTypeString isEqualToString: @"checkuserlist"])
            extendType = WOAExtendTextFieldType_CheckUserList;
    }
    
    return extendType;
}

- (BOOL) couldUserInteractEvenUnWritable: (WOAExtendTextFieldType)extendType
{
    return (extendType == WOAExtendTextFieldType_AttachFile);
}

- (UIView*) rightViewWithExtendType: (WOAExtendTextFieldType)extendType isWritable: (BOOL)isWritable viewHeight: (CGFloat)viewHeight
{
    SEL clickSelector;
    NSString *title;
    
    switch (_extendType)
    {
        case WOAExtendTextFieldType_Normal:
        case WOAExtendTextFieldType_IntString:
            clickSelector = nil;
            title = nil;
            break;
            
        case WOAExtendTextFieldType_DatePicker:
            clickSelector = @selector(showDatePicker:);
            title = @"...";
            break;
            
        case WOAExtendTextFieldType_TimePicker:
            clickSelector = @selector(showTimePicker:);
            title = @"...";
            break;
            
        case WOAExtendTextFieldType_DateTimePicker:
            clickSelector = @selector(showDateTimePicker:);
            title = @"...";
            break;
            
        case WOAExtendTextFieldType_PickerView:
            clickSelector = @selector(showPickerView:);
            title = @"...";
            break;
            
        case WOAExtendTextFieldType_AttachFile:
            if (isWritable)
                clickSelector = @selector(selectAttachment:);
            else
                clickSelector = @selector(viewAttachment:);
            title = @"...";
            break;
            
        case WOAExtendTextFieldType_TextList:
            clickSelector = nil;
            title = nil;
            break;
            
        case WOAExtendTextFieldType_CheckUserList:
            clickSelector = nil;
            title = nil;
            break;
            
        default:
            clickSelector = nil;
            title = nil;
            break;
    }
    
    BOOL couldShouldRightView = ((_isEditable && isWritable) || [self couldUserInteractEvenUnWritable: extendType]);
    
    UIButton *rightButton;
    if (title && couldShouldRightView)
    {
        rightButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [rightButton setTitle: title forState: UIControlStateNormal];
        [rightButton setTitleColor: [UIColor textNormalColor] forState: UIControlStateNormal];
        
        if (clickSelector != nil)
        {
            [rightButton addTarget: self action: clickSelector forControlEvents: UIControlEventTouchDown];
        }
        
        CGFloat viewWidth = viewHeight;
        CGRect rect = CGRectMake(0, 0, viewWidth, viewHeight);
        [rightButton setFrame: rect];
    }
    else
    {
        rightButton = nil;
    }
    
    return rightButton;
}

- (instancetype) initWithFrame: (CGRect)frame
             popoverShowInView: (UIView*)popoverShowInView
                       section: (NSInteger)section
                           row: (NSInteger)row
                    isEditable: (BOOL)isEditable
                     itemModel: (NSDictionary*)itemModel
{
    if (self = [self initWithFrame: frame])
    {
        self.popoverShowInView = popoverShowInView;
        self.section = section;
        self.row = row;
        self.isEditable = isEditable;
        
        NSString *typeString = [WOAPacketHelper itemTypeFromDictionary: itemModel];
        NSString *labelText = [WOAPacketHelper itemNameFromDictionary: itemModel];
        BOOL isWritable = [WOAPacketHelper itemWritableFromDictionary: itemModel];
        
        self.isWritable = isWritable;
        
        id itemValue = [WOAPacketHelper itemValueFromDictionary: itemModel];
        //TO-DO,
        if ([itemValue isKindOfClass: [NSArray class]])
            itemValue = nil;
        
        self.extendType = [self extendTypeFromString: typeString];
        if (self.extendType == WOAExtendTextFieldType_PickerView)
        {
            NSArray *optionArray = [WOAPacketHelper optionArrayFromDictionary: itemModel];
            
            //DO NOT need to sort at client side
            //self.optionArray = [optionArray sortedArrayUsingSelector: @selector(compare:)];
            self.optionArray = optionArray;
        }
        else
        {
            self.optionArray = nil;
        }
        self.label = [[UILabel alloc] initWithFrame: CGRectZero];
        _label.font = [_label.font fontWithSize: 12.0f];
        _label.text = labelText;
        _label.textAlignment = NSTextAlignmentLeft;
        [self addSubview: _label];
        
        self.textField = [[UITextField alloc] initWithFrame: CGRectZero];
        _textField.font = [_textField.font fontWithSize: 12.0f];
        _textField.delegate = self;
        _textField.text = itemValue;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.borderStyle = (isEditable && isWritable) ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
        _textField.userInteractionEnabled = isWritable || [self couldUserInteractEvenUnWritable: _extendType];
        _textField.keyboardType = (_extendType == WOAExtendTextFieldType_IntString) ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
        
        //readonly
        UIView *rightView = [self rightViewWithExtendType: self.extendType isWritable: isWritable viewHeight: kWOALayout_ItemCommonHeight];
        _textField.rightView = rightView;
        _textField.rightViewMode = rightView ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
        
        [self addSubview: _textField];
        
        
        //set frames
        CGFloat originY = kWOALayout_ItemTopMargin;
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
    self.actionSheetPickerView = [[VSActionSheetPickerView alloc] init];
    
    NSInteger selectedRow = [self.optionArray indexOfObject: self.textField.text];
    
    [self.actionSheetPickerView shownPickerViewInView: self.popoverShowInView
                                            dataModel: self.optionArray
                                          selectedRow: selectedRow
                                      selectedHandler: ^(NSInteger row)
    {
        if (row >= 0)
            self.textField.text = [self.optionArray objectAtIndex: row];
    }
                                     cancelledHandler: ^
    {
    }];
}

- (void) showActionSheetDatePicker: (id)sender datePickerMode: (UIDatePickerMode)datePickerMode
{
    self.actionSheetDatePicker = [[VSActionSheetDatePicker alloc] init];
    
    NSString *dateFormatString;
    switch (self.extendType)
    {
        case WOAExtendTextFieldType_DatePicker:
            dateFormatString = kWOADefaultDateFormat;
            break;
            
        case WOAExtendTextFieldType_TimePicker:
            dateFormatString = kWOADefaultTimeFormat;
            break;
            
        case WOAExtendTextFieldType_DateTimePicker:
            dateFormatString = kWOADefaultDateTimeFormat;
            break;
            
        default:
            dateFormatString = nil;
            break;
    }
    
    [self.actionSheetDatePicker showInView: self.popoverShowInView
                            datePickerMode: datePickerMode
                         currentDateString: self.textField.text
                          dateFormatString: dateFormatString
                           selectedHandler: ^(NSString *selectedDateString)
    {
        self.textField.text = selectedDateString;
    }
                     cancelledHandler: ^
    {
    }];
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

- (void) viewAttachment: (id)sender
{
    NSString *filePath = self.textField.text;
    
    if (filePath && [filePath length] > 0)
    {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: filePath]];
    }
}

- (void) selectAttachment: (id)sender
{
    UIImagePickerControllerSourceType sourceType;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    else
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.allowsEditing = NO;
    imagePickerVC.sourceType = sourceType;
    //imagePickerVC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: sourceType];
    imagePickerVC.mediaTypes = @[@"public.image"];
    imagePickerVC.delegate = self;
    
    [self.hostNavigation presentViewController: imagePickerVC animated: YES completion: nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL allowEditing = (_extendType == WOAExtendTextFieldType_Normal ||
                         _extendType == WOAExtendTextFieldType_IntString);
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(textFieldTryBeginEditing:allowEditing:)])
        [self.delegate textFieldTryBeginEditing: textField allowEditing: allowEditing];
    
    return allowEditing;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(textFieldDidBecameFirstResponder:)])
        [self.delegate textFieldDidBecameFirstResponder: textField];
}

- (NSDictionary*) toDataModelWithIndexPath
{
    NSNumber *sectionNum = [NSNumber numberWithInteger: self.section];
    NSNumber *rowNum = [NSNumber numberWithInteger: self.row];
    
    NSString *value;
    if (self.isWritable && (_extendType == WOAExtendTextFieldType_AttachFile))
    {
        value = self.imageFileNameInServer;
    }
    else
    {
        value = self.textField.text;
    }
    
    return [WOAPacketHelper packetForItemWithKey: self.label.text
                                           value: value
                                         section: sectionNum
                                             row: rowNum];
}

- (void) selectDefaultValueFromPickerView
{
    if (self.extendType == WOAExtendTextFieldType_PickerView)
    {
        if ([_textField.text length] <= 0)
        {
            _textField.text = [self.optionArray firstObject];
        }
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController: (UIImagePickerController *)picker
 didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    NSURL *imageURL = [info valueForKey: UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *targetAsset)
    {
        ALAssetRepresentation *defaultRepresentation = [targetAsset defaultRepresentation];
        self.imageFileName = [defaultRepresentation filename];
        self.imageFileSize = [defaultRepresentation size];
        
        self.textField.text = self.imageFileName;
        
        NSString *tempPath = [NSFileManager currentAccountTempPath];
        self.imageFullFileName = [NSString stringWithFormat: @"%@/%@", tempPath, self.imageFileName];
        self.imageFileNameInServer = nil;
        
        [NSFileManager createDirectoryIfNotExists: tempPath];
        
        Byte *buffer = (Byte*)malloc((unsigned long) self.imageFileSize);
        NSUInteger length = [defaultRepresentation getBytes: buffer fromOffset: 0.0 length: (NSUInteger)self.imageFileSize error: nil];
        NSData *data = [[NSData alloc] initWithBytesNoCopy: buffer length: length freeWhenDone: YES];
        if (![data writeToFile: self.imageFullFileName atomically: YES])
        {
            NSLog(@"Dump image failed.");
        }
        
        [picker dismissViewControllerAnimated: YES completion: nil];
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        NSLog(@"image picker error: %@", error);
        
        [picker dismissViewControllerAnimated: YES completion: nil];
    };
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL: imageURL
                   resultBlock: resultBlock
                  failureBlock: failureBlock];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated: YES completion: nil];
}

@end





