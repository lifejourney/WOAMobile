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

+ (UIColor*) navigationItemNormalColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) tabbarItemNormalColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) tabbarItemSelectedColor
{
    return [UIColor colorWithRed: 231/255.f green: 222/255.f blue: 127/255.f alpha: 1.0];
}

+ (UIColor*) textNormalColor
{
    return [UIColor blackColor];
}

+ (UIColor*) textHighlightedColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) listLightColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) listHeavyColor
{
    return [UIColor lightGrayColor];
}

@end
