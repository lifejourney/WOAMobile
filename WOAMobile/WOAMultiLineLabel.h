//
//  WOAMultiLineLabel.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOAMultiLineLabel : UIView

@property (nonatomic, strong) NSArray *textsArray;

- (instancetype) initWithFrame: (CGRect)frame
                    textsArray: (NSArray*)textsArray;

@end
