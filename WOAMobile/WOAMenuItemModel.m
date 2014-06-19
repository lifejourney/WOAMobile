//
//  WOAMenuItemModel.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMenuItemModel.h"


@implementation WOAMenuItemModel

+ (WOAMenuItemModel*) menuItemModel: (NSString*)itemID
                              title: (NSString*)title
                          imageName: (NSString*)imageName
                      showAccessory: (BOOL)showAccessory
{
    WOAMenuItemModel *item = [[WOAMenuItemModel alloc] init];
    
    item.itemID = itemID;
    item.title = title;
    item.imageName = imageName;
    item.showAccessory = showAccessory;
    
    return item;
}

@end
