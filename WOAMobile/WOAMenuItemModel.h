//
//  WOAMenuItemModel.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WOAMenuItemModel : NSObject

@property (nonatomic, copy) NSString *itemID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL showAccessory;

+ (WOAMenuItemModel*) menuItemModel: (NSString*)itemID
                              title: (NSString*)title
                          imageName: (NSString*)imageName
                      showAccessory: (BOOL)showAccessory;

@end
