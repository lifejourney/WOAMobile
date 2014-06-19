//
//  UIColor+AppTheme.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "UIColor+AppTheme.h"


@implementation UIColor (AppTheme)

+ (UIColor*) mainColor
{
    //TO-DO
    //return [UIColor colorWithRed:  green:  blue:  alpha: ];
    return [UIColor orangeColor];
}

+ (UIColor*) textNormalColor
{
    return [UIColor blackColor];
}

+ (UIColor*) textHighlightedColor
{
    return [UIColor whiteColor];
}

@end
