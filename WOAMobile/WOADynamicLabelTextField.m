//
//  WOADynamicLabelTextField.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/11/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOADynamicLabelTextField.h"
#import "WOAPacketHelper.h"
#import "WOAPickerViewController.h"
#import "WOADateTimePickerViewController.h"
#import "WOAMultiLineLabel.h"
#import "WOAFileSelectorView.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOADynamicLabelTextField () <UITextFieldDelegate,
                                        UITextViewDelegate,
                                        WOAFileSelectorViewDelegate,
                                        WOAMultiLineLabelDelegate,
                                        WOAPickerViewControllerDelegate,
                                        WOADateTimePickerViewControllerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WOAMultiLineLabel *multiLabel;
@property (nonatomic, strong) WOAFileSelectorView *fileSelectorView;
@property (nonatomic, strong) UITextField *lineTextField;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UITextView *lineTextView;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) BOOL isWritable;

//TO-DO: weak? strong?
@property (nonatomic, weak) UIView *popoverShowInView;

@property (nonatomic, assign) WOAExtendTextFieldType extendType;
@property (nonatomic, assign) NSString *extendTypeString;
@property (nonatomic, strong) NSArray *optionArray;

@property (nonatomic, strong) WOAPickerViewController *pickerVC;
@property (nonatomic, strong) WOADateTimePickerViewController *datePickerVC;

@end

@implementation WOADynamicLabelTextField

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageFullFileNameArray = [[NSMutableArray alloc] initWithCapacity: 3];
        self.imageTitleArray = [[NSMutableArray alloc] initWithCapacity: 3];
        self.imageURLArray = [[NSMutableArray alloc] initWithCapacity: 3];
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

//- (UIView*) rightViewWithExtendType: (WOAExtendTextFieldType)extendType isWritable: (BOOL)isWritable viewHeight: (CGFloat)viewHeight
- (SEL) clickSelectorWithExtendType: (WOAExtendTextFieldType)extendType
                         isWritable: (BOOL)isWritable
{
    SEL clickSelector;
    
    switch (_extendType)
    {
        case WOAExtendTextFieldType_Normal:
        case WOAExtendTextFieldType_IntString:
            clickSelector = nil;
            break;
            
        case WOAExtendTextFieldType_DatePicker:
        case WOAExtendTextFieldType_TimePicker:
        case WOAExtendTextFieldType_DateTimePicker:
            clickSelector = @selector(showDatePickerView:);
            break;
            
        case WOAExtendTextFieldType_PickerView:
            clickSelector = @selector(showPickerView:);
            break;
            
        case WOAExtendTextFieldType_AttachFile:
            clickSelector = nil;
            break;
            
        case WOAExtendTextFieldType_TextList:
            clickSelector = nil;
            break;
            
        case WOAExtendTextFieldType_CheckUserList:
            clickSelector = nil;
            break;
            
        default:
            clickSelector = nil;
            break;
    }
    
    
    BOOL couldShouldRightView = ((_isEditable && isWritable) || [self couldUserInteractEvenUnWritable: extendType]);
    
    if (!couldShouldRightView)
    {
        clickSelector = nil;
    }

    return clickSelector;
}

- (UIImageView*) rightViewWithExtendType: (WOAExtendTextFieldType)extendType
                              isWritable: (BOOL)isWritable
{
    UIImage *buttonImage;
    UIImage *dropDownImage = [UIImage imageNamed: @"DropDownIcon"];
    
    switch (_extendType)
    {
        case WOAExtendTextFieldType_Normal:
        case WOAExtendTextFieldType_IntString:
            buttonImage = nil;
            break;
            
        case WOAExtendTextFieldType_DatePicker:
        case WOAExtendTextFieldType_TimePicker:
        case WOAExtendTextFieldType_DateTimePicker:
            buttonImage = dropDownImage;
            break;
            
        case WOAExtendTextFieldType_PickerView:
            buttonImage = dropDownImage;
            break;
            
        case WOAExtendTextFieldType_AttachFile:
            buttonImage = dropDownImage;
            break;
            
        case WOAExtendTextFieldType_TextList:
            buttonImage = nil;
            break;
            
        case WOAExtendTextFieldType_CheckUserList:
            buttonImage = nil;
            break;
            
        default:
            buttonImage = nil;
            break;
    }
    
    
    BOOL couldShouldRightView = ((_isEditable && isWritable) || [self couldUserInteractEvenUnWritable: extendType]);
    
    if (!couldShouldRightView)
    {
        buttonImage = nil;
    }

    return buttonImage ? [[UIImageView alloc] initWithImage: buttonImage] : nil;
}

- (void) addRightViewForTextField: (UITextField*)textField
                       extendType: (WOAExtendTextFieldType)extendType
                       isWritable: (BOOL)isWritable
{
    SEL clickSelector = [self clickSelectorWithExtendType: extendType isWritable: isWritable];
    UIImageView *rightView = [self rightViewWithExtendType: extendType isWritable: isWritable];
    
    [textField addTarget: self action: clickSelector forControlEvents: UIControlEventTouchDown];
    textField.rightView = rightView;
    textField.rightViewMode = rightView ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
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
        
        self.extendTypeString = typeString;
        self.isWritable = isWritable;
        
        id itemValue = [WOAPacketHelper itemValueFromDictionary: itemModel];
        NSString *textValue;
        NSArray *arrayValue;
        //TO-DO,
        if ([itemValue isKindOfClass: [NSArray class]])
        {
            textValue = nil;
            arrayValue = itemValue;
        }
        else
        {
            textValue = itemValue;
            arrayValue = nil;
        }
        
        self.extendType = [self extendTypeFromString: typeString];
        if (_extendType == WOAExtendTextFieldType_PickerView)
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
        
        
        UILabel *testLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        UIFont *labelFont = [testLabel.font fontWithSize: kWOALayout_DetailItemFontSize];
        BOOL shouldShowInputTextField = YES;
        //set frames
        CGFloat originY = kWOALayout_ItemTopMargin;
        CGFloat sizeHeight = kWOALayout_ItemCommonHeight;
        CGFloat labelOriginX = frame.origin.x;
        CGFloat labelWidth = kWOALayout_ItemLabelWidth;
        CGFloat textOriginX = labelOriginX + labelWidth + kWOALayout_ItemLabelTextField_Gap;
        CGFloat textWidth = frame.size.width - textOriginX;
        
        
        CGSize titleLabelSize = [WOALayout sizeForText: labelText
                                                 width: labelWidth
                                                  font: labelFont];
        self.titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, titleLabelSize.width, titleLabelSize.height)];
        _titleLabel.font = labelFont;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = labelText;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview: _titleLabel];
        
        CGRect initiateFrame = frame;
        initiateFrame.size.width = textWidth;
        
        if ((_extendType == WOAExtendTextFieldType_TextList) || (_extendType == WOAExtendTextFieldType_CheckUserList))
        {
            //TO-DO, temporarily
            if (_extendType == WOAExtendTextFieldType_CheckUserList)
            {
                if (!arrayValue && textValue)
                    arrayValue = @[textValue];
            }
            
            CGRect initiateFrame = frame;
            initiateFrame.size.width = textWidth;
            self.multiLabel = [[WOAMultiLineLabel alloc] initWithFrame: initiateFrame
                                                            textsArray: arrayValue
                                                          isAttachment: NO];
            
            [self addSubview: _multiLabel];
            
            if (!_isWritable)
                shouldShowInputTextField = NO;
        }
        else if (_extendType == WOAExtendTextFieldType_AttachFile)
        {
            if (_isWritable)
            {
                self.fileSelectorView = [[WOAFileSelectorView alloc] initWithFrame: initiateFrame
                                                                          delegate: self];
                
                [self addSubview: _fileSelectorView];
                
            }
            else
            {
                self.multiLabel = [[WOAMultiLineLabel alloc] initWithFrame: initiateFrame
                                                                textsArray: arrayValue
                                                              isAttachment: YES];
                _multiLabel.delegate = self;
                
                [self addSubview: _multiLabel];
            }
            
            shouldShowInputTextField = NO;
        }
        
        if (!_isWritable && (_extendType == WOAExtendTextFieldType_Normal))
        {
            CGSize onelineSize = [WOALayout sizeForText: textValue
                                                  width: textWidth
                                                   font: labelFont];
            
            self.lineLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, onelineSize.width, onelineSize.height)];
            _lineLabel.font = labelFont;
            _lineLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _lineLabel.numberOfLines = 0;
            _lineLabel.text = textValue;
            _lineLabel.textAlignment = NSTextAlignmentLeft;
            _lineLabel.userInteractionEnabled = NO;
            
            [self addSubview: _lineLabel];
        }
        else if (shouldShowInputTextField)
        {
            if (0 && _isWritable && (_extendType == WOAExtendTextFieldType_Normal ||
                                _extendType == WOAExtendTextFieldType_TextList ||
                                _extendType == WOAExtendTextFieldType_CheckUserList))
            {
                NSString *testString = @"test1\r\n\test2";
                CGSize testSize = [WOALayout sizeForText: testString
                                                   width: textWidth
                                                    font: labelFont];
                CGSize textViewSize = [WOALayout sizeForText: textValue
                                                       width: textWidth
                                                        font: labelFont];
                textViewSize.height = MAX(testSize.height, textViewSize.height);
                
                self.lineTextView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, textViewSize.width, textViewSize.height)];
                _lineTextView.font = [_lineTextView.font fontWithSize: kWOALayout_DetailItemFontSize];
                _lineTextView.delegate = self;
                _lineTextView.text = textValue;
                _lineTextView.textAlignment = NSTextAlignmentLeft;
                _lineTextView.userInteractionEnabled = YES;
                _lineTextView.keyboardType = UIKeyboardTypeDefault;
                
                [self addSubview: _lineTextView];
            }
            else
            {
                self.lineTextField = [[UITextField alloc] initWithFrame: CGRectZero];
                _lineTextField.font = [_lineTextField.font fontWithSize: kWOALayout_DetailItemFontSize];
                _lineTextField.delegate = self;
                _lineTextField.text = textValue;
                _lineTextField.textAlignment = NSTextAlignmentLeft;
                _lineTextField.borderStyle = (isEditable && _isWritable) ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
                _lineTextField.userInteractionEnabled = _isWritable || [self couldUserInteractEvenUnWritable: _extendType];
                _lineTextField.keyboardType = (_extendType == WOAExtendTextFieldType_IntString) ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
                
                [self addRightViewForTextField: _lineTextField extendType:_extendType isWritable: _isWritable];
                
                [self addSubview: _lineTextField];
            }
        }
        
        CGFloat multiLabelHeight = _multiLabel ? _multiLabel.frame.size.height : 0;
        CGFloat titleSizeHeight = MAX(sizeHeight, originY + _titleLabel.frame.size.height);
        CGFloat lineLabelHeight = _lineLabel ? _lineLabel.frame.size.height : 0;
        CGFloat fileSelectorHeight = _fileSelectorView ? _fileSelectorView.frame.size.height : 0;
        CGFloat textFieldSizeHeight = _lineTextField ? sizeHeight : 0;
        CGFloat textViewSizeHeight = _lineTextView ? _lineTextView.frame.size.height : 0;
        if (!shouldShowInputTextField)
        {
            if (multiLabelHeight != 0)
            {
                textFieldSizeHeight = 0;
                textViewSizeHeight = 0;
            }
        }
        CGFloat placeHolderSizeHeight = originY + multiLabelHeight + lineLabelHeight + fileSelectorHeight + textFieldSizeHeight + textViewSizeHeight;
        CGRect labelRect = CGRectMake(labelOriginX, originY, labelWidth, titleSizeHeight);
        CGRect multiLabelRect = CGRectMake(textOriginX, originY, textWidth, multiLabelHeight);
        CGRect textFieldRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, textFieldSizeHeight);
        CGRect textViewRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, textViewSizeHeight);
        CGRect lineLabelRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, lineLabelHeight);
        CGRect fileSelectorRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, fileSelectorHeight);
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MAX(titleSizeHeight, placeHolderSizeHeight));
        
        [self setFrame: selfRect];
        [_titleLabel setFrame: labelRect];
        [_multiLabel setFrame: multiLabelRect];
        [_lineTextField setFrame: textFieldRect];
        [_lineTextView setFrame: textViewRect];
        [_lineLabel setFrame: lineLabelRect];
        [_fileSelectorView setFrame: fileSelectorRect];
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void) showPickerView: (id)sender
{
    NSInteger selectedRow = [self.optionArray indexOfObject: self.lineTextField.text];
    
    _pickerVC = [[WOAPickerViewController alloc] initWithDelgate: self
                                                           title: _titleLabel.text
                                                       dataModel: _optionArray
                                                     selectedRow: selectedRow];
    
    [[self hostNavigation] pushViewController: _pickerVC animated: NO];
}

- (void) showDatePickerView: (id)sender
{
    NSString *dateFormatString;
    switch (_extendType)
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
    
    _datePickerVC = [[WOADateTimePickerViewController alloc] initWithDelgate: self
                                                                       title: _titleLabel.text
                                                           defaultDateString: _lineTextField.text
                                                                formatString: dateFormatString];
    
    [[self hostNavigation] pushViewController: _datePickerVC animated: NO];
}

- (BOOL) isPureIntegerString: (NSString*)src
{
    NSScanner *scanner = [NSScanner scannerWithString: src];
    NSInteger val;
    
    return ([scanner scanInteger: &val] && [scanner isAtEnd]);
}

- (NSString*) removeNumberOrderPrefix: (NSString*)src
{
    NSString *retString = src;
    NSString *delimeter = @".";
    NSRange range = [src rangeOfString: delimeter];
    if (range.length > 0)
    {
        NSString *prefix = [src substringToIndex: range.location];
        if (prefix && [prefix length] > 0)
        {
            if ([self isPureIntegerString: prefix])
            {
                NSUInteger fromIndex = range.location + range.length;
                
                retString = [src substringFromIndex: fromIndex];
            }
        }
    }
    
    return retString;
}

- (NSDictionary*) toDataModelWithIndexPath
{
    NSNumber *sectionNum = [NSNumber numberWithInteger: self.section];
    NSNumber *rowNum = [NSNumber numberWithInteger: self.row];
    
    id value;
    
    if (_isWritable && (_extendType == WOAExtendTextFieldType_PickerView))
    {
        value = [self removeNumberOrderPrefix: self.lineTextField.text];
    }
    else if (!_isWritable && (_extendType == WOAExtendTextFieldType_Normal))
    {
        value = self.lineLabel.text;
    }
    else if (_extendType == WOAExtendTextFieldType_AttachFile)
    {
        if (_isWritable)
        {
            NSMutableArray *attachmentArray = [[NSMutableArray alloc] initWithCapacity: _imageURLArray.count];
            
            for (NSInteger index = 0; index < _imageURLArray.count; index++)
            {
                NSDictionary *attachmentInfo = @{@"title": self.imageTitleArray[index],
                                                 @"url": self.imageURLArray[index]};
                
                [attachmentArray addObject: attachmentInfo];
            }
            
            value = attachmentArray;
        }
        else
        {
            value = nil;
            //TO-DO:
            //value = self.multiLabel.textsArray;
        }
    }
    else if (0 && _isWritable && (_extendType == WOAExtendTextFieldType_Normal ||
                             _extendType == WOAExtendTextFieldType_TextList ||
                             _extendType == WOAExtendTextFieldType_CheckUserList))
    {
        value = self.lineTextView.text;
    }
//TO-DO:
//    else if (_extendType == WOAExtendTextFieldType_TextList)
//    {
//        NSString *userInputValue = self.lineTextField.text;
//        NSMutableArray *arrayValue = [[NSMutableArray alloc] initWithArray: self.multiLabel.textsArray];
//        if (userInputValue && [userInputValue length] > 0)
//        {
//            [arrayValue addObject: userInputValue];
//        }
//
//        value = arrayValue;
//    }
//    else if (_extendType == WOAExtendTextFieldType_CheckUserList)
//    {
//        value = self.multiLabel.textsArray;
//    }
    else
    {
        value = self.lineTextField.text;
    }
    
    return [WOAPacketHelper packetForItemWithKey: self.titleLabel.text
                                           value: value
                                      typeString: self.extendTypeString
                                         section: sectionNum
                                             row: rowNum];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //TO-DO
    BOOL allowEditing = (_extendType == WOAExtendTextFieldType_Normal ||
                         _extendType == WOAExtendTextFieldType_IntString ||
                         _extendType == WOAExtendTextFieldType_TextList ||
                         _extendType == WOAExtendTextFieldType_CheckUserList);
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(textFieldTryBeginEditing:allowEditing:)])
        [self.delegate textFieldTryBeginEditing: textField allowEditing: allowEditing];
    
    return allowEditing;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(textFieldDidBecameFirstResponder:)])
        [self.delegate textFieldDidBecameFirstResponder: textField];
}

- (void) selectDefaultValueFromPickerView
{
    if (_extendType == WOAExtendTextFieldType_PickerView)
    {
        if ([_lineTextField.text length] <= 0)
        {
            _lineTextField.text = [self.optionArray firstObject];
        }
    }
}

#pragma mark -

- (NSArray*) fileInfoArray
{
    return _imageTitleArray;
}

- (void) fileSelectorView: (WOAFileSelectorView *)fileSelectorView
              addFilePath: (NSString *)filePath
                withTitle: (NSString *)title
{
    fileSelectorView.delegate = nil;
    
    [self.imageFullFileNameArray addObject: filePath];
    [self.imageTitleArray addObject: title];
    
    fileSelectorView.delegate = self;
    [fileSelectorView fileInfoUpdated];
}

- (void) fileSelectorView: (WOAFileSelectorView *)fileSelectorView
              deleteAtRow:(NSInteger)row
{
    fileSelectorView.delegate = nil;
    
    [self.imageFullFileNameArray removeObjectAtIndex: row];
    [self.imageTitleArray removeObjectAtIndex: row];
    
    fileSelectorView.delegate = self;
    [fileSelectorView fileInfoUpdated];
}

#pragma mark - 

- (void) pickerViewController: (WOAPickerViewController *)pickerViewController
                  selectAtRow: (NSInteger)row
                fromDataModel:(NSArray *)dataModel
{
    if (row >= 0)
    {
        self.lineTextField.text = [dataModel objectAtIndex: row];
    }
    
    _pickerVC = nil;
}

- (void) pickerViewControllerCancelled: (WOAPickerViewController *)pickerViewController
{
    _pickerVC = nil;
}

#pragma mark - 

- (void) dateTimePickerViewController: (WOADateTimePickerViewController *)dateTimePickerViewController
                   selectedDateString: (NSString *)selectedDateString
{
    self.lineTextField.text = selectedDateString;
    
    _datePickerVC = nil;
}

- (void) dateTimePickerViewControllerCancelled: (WOADateTimePickerViewController *)dateTimePickerViewController
{
    _datePickerVC = nil;
}

@end





