//
//  VSActionSheetDatePicker.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/10/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VSActionSheetDatePicker : NSObject

- (void) showInView: (UIView*)view
     datePickerMode: (UIDatePickerMode)datePickerMode
        currentDate: (NSDate*)currentDate
    selectedHandler: (void (^)(NSDate* selectedDate))selectedHandler
   cancelledHandler: (void (^)())cancelledHandler;

- (void) showInView: (UIView*)view
     datePickerMode: (UIDatePickerMode)datePickerMode
        currentDate: (NSDate*)currentDate
   outputDateFormat: (NSString*)outputDateFormat
    selectedHandler: (void (^)(NSString* selectedDateString))selectedHandler
   cancelledHandler: (void (^)())cancelledHandler;

@end
