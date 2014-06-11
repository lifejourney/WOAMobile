//
//  VSActionSheetPickerView.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/12/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "VSActionSheetPickerView.h"


@interface VSActionSheetPickerView () <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *dataModel;
@property (nonatomic, copy) void (^selectedSingleColumnHandler)(NSInteger row);
@property (nonatomic, copy) void (^selectedDoubleColumnHandler)(NSInteger column, NSInteger row);
@property (nonatomic, copy) void (^cancelledHandler)();

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger selectedColumn;
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation VSActionSheetPickerView

- (instancetype) init
{
    if (self = [super init])
    {
        self.selectedColumn = -1;
        self.selectedRow = -1;
    }
    
    return self;
}

- (void) showSingleColumnPickerViewInView: (UIView*)view
                                dataModel: (NSArray*)dataModel
                          selectedHandler: (void (^)(NSInteger row))selectedHandler
                         cancelledHandler: (void (^)())cancelledHandler
{
    self.dataModel = dataModel;
    self.selectedSingleColumnHandler = selectedHandler;
    self.selectedDoubleColumnHandler = nil;
    self.cancelledHandler = cancelledHandler;
    
    //TO-DO
    NSMutableString *title = [[NSMutableString alloc] initWithString: @"\n"];
    for (NSInteger i = 0; i < [dataModel count]; i++)
        [title appendString: @"\n"];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: title
                                                             delegate: self
                                                    cancelButtonTitle: @"取消"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"确定", nil];
    if (!_pickerView)
    {
        //TO-DO
        CGFloat height = 30 * [dataModel count] + 10;
        CGRect rect = CGRectMake(0, 0, view.frame.size.width, height);
        
        _pickerView = [[UIPickerView alloc] initWithFrame: rect];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    
    [actionSheet addSubview: _pickerView];
    [actionSheet showInView: view];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return _selectedDoubleColumnHandler ? 2 : 1;
}

- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    //TO-DO, only single line now
    return _dataModel ? [_dataModel count] : 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component;
{
    //TO-DO, only single line now
    if (_selectedDoubleColumnHandler)
    {
        return @"";
    }
    else
    {
        return [_dataModel objectAtIndex: row];
    }
}

- (void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    _selectedColumn = component;
    _selectedRow = row;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && _selectedColumn != -1 && _selectedRow != -1)
    {
        if (_selectedDoubleColumnHandler)
        {
            _selectedDoubleColumnHandler(_selectedColumn, _selectedRow);
        }
        else if (_selectedSingleColumnHandler)
        {
            _selectedSingleColumnHandler(_selectedRow);
        }
    }
    else
    {
        _cancelledHandler();
    }
}


@end





