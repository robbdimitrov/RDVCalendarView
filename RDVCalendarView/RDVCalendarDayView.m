//
//  RDVCalendarDayView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarDayView.h"

@implementation RDVCalendarDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:20]];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGSize titleSize = [[self titleLabel] sizeThatFits:CGSizeMake(frameSize.width, frameSize.height)];
    
    [[self titleLabel] setFrame:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2),
                                           roundf(frameSize.height / 2 - titleSize.height / 2),
                                           titleSize.width, titleSize.height)];
}

@end
