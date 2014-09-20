//
//  VSAlertControllerPickerView.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSAlertControllerPickerView : NSObject

- (void) shownPickerViewInView: (UIView*)view
                     dataModel: (NSArray*)dataModel
                   selectedRow: (NSInteger) selectedRow
               selectedHandler: (void (^)(NSInteger row))selectedHandler
              cancelledHandler: (void (^)())cancelledHandler;

@end
