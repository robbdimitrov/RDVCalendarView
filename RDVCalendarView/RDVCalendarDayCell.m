//
//  RDVCalendarDayCell.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarDayCell.h"

@interface RDVCalendarDayCell() {
    BOOL _selected;
}

@end

@implementation RDVCalendarDayCell

- (id)initWithStyle:(RDVCalendarDayCellSelectionStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _backgroundView = [[UIView alloc] init];
        [_backgroundView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_backgroundView];
        
        _selectedBackgroundView = [[UIView alloc] init];
        [_selectedBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
        [_selectedBackgroundView setAlpha:0];
        [self addSubview:_selectedBackgroundView];
        
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_contentView addSubview:_titleLabel];
    }
    return self;
}

- (id)init {
    return [self initWithStyle:RDVCalendarDayCellSelectionStyleNormal reuseIdentifier:nil];
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGSize titleSize = [[self titleLabel] sizeThatFits:CGSizeMake(frameSize.width, frameSize.height)];
    
    [[self backgroundView] setFrame:self.bounds];
    [[self selectedBackgroundView] setFrame:self.bounds];
    [[self contentView] setFrame:self.bounds];
    
    [[self titleLabel] setFrame:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2),
                                           roundf(frameSize.height / 2 - titleSize.height / 2),
                                           titleSize.width, titleSize.height)];
}

- (BOOL)isSelected {
    return _selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    void (^block)() = ^{
        if (selected) {
            [[self backgroundView] setAlpha:0];
            [[self selectedBackgroundView] setAlpha:1];
        } else {
            [[self backgroundView] setAlpha:1];
            [[self selectedBackgroundView] setAlpha:0];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:block];
    } else {
        block();
    }
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:YES];
}

- (void)prepareForReuse {
    
}

@end
