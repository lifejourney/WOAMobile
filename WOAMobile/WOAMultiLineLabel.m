//
//  WOAMultiLineLabel.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMultiLineLabel.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOAMultiLineLabel ()

@end


@implementation WOAMultiLineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype) initWithFrame: (CGRect)frame
                    textsArray: (NSArray*)textsArray;
{
    if (self = [self initWithFrame: frame])
    {
        self.textsArray = textsArray;
        
        CGFloat originY = 0;
        
        UILabel *testLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        UIFont *labelFont = [testLabel.font fontWithSize: kWOALayout_DetailItemFontSize];
        
        CGFloat lineMargin = kWOALayout_ItemTopMargin;
        CGFloat viewWidth = frame.size.width;
        CGFloat viewHeight = 0;
        CGFloat onelineWidth = viewWidth;
        CGSize onelineSize;
        for (NSInteger index = 0; index < [textsArray count]; index++)
        {
            onelineSize = [WOALayout sizeForText: [textsArray objectAtIndex: index]
                                           width: onelineWidth
                                            font: labelFont];
            
            viewHeight += onelineSize.height + lineMargin;
        }
        
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, viewWidth, viewHeight);
        [self setFrame: selfRect];
        
        for (NSInteger index = 0; index < [textsArray count]; index++)
        {
            originY += lineMargin;
            
            onelineSize = [WOALayout sizeForText: [textsArray objectAtIndex: index]
                                           width: onelineWidth
                                            font: labelFont];
            CGRect textRect = CGRectMake(0, originY, onelineSize.width, onelineSize.height);
            
            UILabel *oneLineLabel = [[UILabel alloc] initWithFrame: textRect];
            oneLineLabel.font = labelFont;
            oneLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
            oneLineLabel.numberOfLines = 0;
            oneLineLabel.text = [textsArray objectAtIndex: index];
            oneLineLabel.textAlignment = NSTextAlignmentLeft;
            oneLineLabel.userInteractionEnabled = NO;
            
            [self addSubview: oneLineLabel];
            
            originY += onelineSize.height;
        }
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

@end
