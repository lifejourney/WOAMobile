//
//  VSSelectedTableViewCell.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "VSSelectedTableViewCell.h"

@implementation VSSelectedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectButton = [UIButton buttonWithType: UIButtonTypeCustom];
        //TO-DO
        //[_selectButton setImage:  forState: UIControlStateNormal];
        //[_selectButton setImage:  forState: UIControlStateSelected];
        [_selectButton setTitle: @"" forState: UIControlStateNormal];
        [_selectButton setTitle: @"O" forState: UIControlStateSelected];
        [_selectButton setAdjustsImageWhenHighlighted: NO];
        [_selectButton addTarget: self action: @selector(selectButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: _selectButton];
        
        self.contentLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview: _contentLabel];
    }
    return self;
}

- (instancetype) initWithStyle: (UITableViewCellStyle)style
               reuseIdentifier: (NSString *)reuseIdentifier
                       section: (NSInteger)section
                           row: (NSInteger)row
                      delegate: (NSObject<VSSelectedTableViewCellDelegate>*)delegate
{
    if (self = [self initWithStyle: style reuseIdentifier: reuseIdentifier])
    {
        self.section = section;
        self.row = row;
        self.delegate = delegate;
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.selectButton.frame = CGRectMake(0, 6, 32, 32);
    self.contentLabel.frame = CGRectMake(32+1, 6, self.contentView.frame.size.width - 33, 32);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) selectButtonAction: (id)sender
{   
    if (_delegate && [_delegate respondsToSelector: @selector(actionForTableViewCell:)])
    {
        [_delegate actionForTableViewCell: self];
    }
}

@end
