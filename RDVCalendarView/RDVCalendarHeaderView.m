//
//  RDVCalendarHeaderView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/26/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarHeaderView.h"

@implementation RDVCalendarHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:22]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [self addSubview:_titleLabel];
        
        _previousMonthButton = [[UIButton alloc] init];
        [_previousMonthButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_previousMonthButton setTitle:@"Prev" forState:UIControlStateNormal];
        [_previousMonthButton addTarget:self action:@selector(previousMonthButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_previousMonthButton];
        
        _nextMonthButton = [[UIButton alloc] init];
        [_nextMonthButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_nextMonthButton setTitle:@"Next" forState:UIControlStateNormal];
        [_nextMonthButton addTarget:self action:@selector(nextMonthButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextMonthButton];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    
    CGSize previousMonthButtonSize = [[self previousMonthButton] sizeThatFits:CGSizeMake(100, 50)];
    CGSize nextMonthButtonSize = [[self nextMonthButton] sizeThatFits:CGSizeMake(100, 50)];
    CGSize titleSize = [[self titleLabel] sizeThatFits:CGSizeMake(viewSize.width - previousMonthButtonSize.width -
                                                                  nextMonthButtonSize.width, 50)];
    
    [self.previousMonthButton setFrame:CGRectMake(10, roundf(viewSize.height / 2 - previousMonthButtonSize.height / 2),
                                                  previousMonthButtonSize.width, previousMonthButtonSize.height)];
    
    [self.titleLabel setFrame:CGRectMake(roundf(viewSize.width / 2 - titleSize.width / 2),
                                         roundf(viewSize.height / 2 - titleSize.height / 2),
                                         titleSize.width, titleSize.height)];
    
    [self.nextMonthButton setFrame:CGRectMake(viewSize.width - 10 - nextMonthButtonSize.width,
                                              roundf(viewSize.height / 2 - nextMonthButtonSize.height / 2),
                                              nextMonthButtonSize.width, nextMonthButtonSize.height)];
}

@end
