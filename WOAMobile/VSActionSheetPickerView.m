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
@property (nonatomic, copy) void (^selectedHandler)(NSInteger row);
@property (nonatomic, copy) void (^cancelledHandler)();

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation VSActionSheetPickerView

- (instancetype) init
{
    if (self = [super init])
    {
        self.selectedRow = -1;
    }
    
    return self;
}

- (void) shownPickerViewInView: (UIView*)view
                     dataModel: (NSArray*)dataModel
                   selectedRow: (NSInteger) selectedRow
               selectedHandler: (void (^)(NSInteger row))selectedHandler
              cancelledHandler: (void (^)())cancelledHandler;
{
    self.dataModel = dataModel;
    self.selectedHandler = selectedHandler;
    self.cancelledHandler = cancelledHandler;
    
    //TO-DO
    NSString *title = @"\n\n\n\n\n\n\n\n\n";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: title
                                                             delegate: self
                                                    cancelButtonTitle: @"取消"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"确定", nil];
    if (!_pickerView)
    {
        //TO-DO
        CGFloat height = 160;
        CGRect rect = CGRectMake(0, 0, view.frame.size.width, height);
        
        _pickerView = [[UIPickerView alloc] initWithFrame: rect];
        _pickerView.showsSelectionIndicator = YES;
//        //TO-DO
//        _pickerView.backgroundColor = [UIColor redColor];
//        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [_pickerView setFrame: rect];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    
    if (selectedRow < 0 || selectedRow >= [dataModel count])
        self.selectedRow = 0;
    else
        self.selectedRow = selectedRow;
    
    [_pickerView selectRow: self.selectedRow inComponent: 0 animated: YES];
    
    [actionSheet addSubview: _pickerView];
    [actionSheet showInView: view];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return _dataModel ? [_dataModel count] : 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component;
{
    return [_dataModel objectAtIndex: row];
}

- (void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    _selectedRow = row;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && _selectedRow != -1)
    {
        _selectedHandler(_selectedRow);
    }
    else
    {
        _cancelledHandler();
    }
}


@end





