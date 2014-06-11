//
//  VSActionSheetPickerView.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/12/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VSActionSheetPickerView : NSObject

- (void) showSingleColumnPickerViewInView: (UIView*)view
                                dataModel: (NSArray*)dataModel
                          selectedHandler: (void (^)(NSInteger row))selectedHandler
                         cancelledHandler: (void (^)())cancelledHandler;
@end
