//
//  RDVCalendarView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarView.h"
#import "RDVCalendarDayView.h"

@implementation RDVCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleView = [[UILabel alloc] init];
        [_titleView setFont:[UIFont systemFontOfSize:22]];
        [_titleView setTextColor:[UIColor blackColor]];
        [self addSubview:_titleView];
        
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
    
    CGSize previousMonthButtonSize = [_previousMonthButton sizeThatFits:CGSizeMake(100, 50)];
    CGSize nextMonthButtonSize = [_nextMonthButton sizeThatFits:CGSizeMake(100, 50)];
    CGSize titleSize = [_titleView sizeThatFits:CGSizeMake(viewSize.width - previousMonthButtonSize.width - nextMonthButtonSize.width, 50)];
    
    [_previousMonthButton setFrame:CGRectMake(10, 20, previousMonthButtonSize.width, previousMonthButtonSize.height)];
    [_titleView setFrame:CGRectMake(roundf(viewSize.width / 2 - titleSize.width / 2),
                                    18, titleSize.width, titleSize.height)];
    [_nextMonthButton setFrame:CGRectMake(viewSize.width - 10 - nextMonthButtonSize.width, 20, nextMonthButtonSize.width, nextMonthButtonSize.height)];
}

- (void)previousMonthButtonTapped:(id)sender {
    // show previous month
}

- (void)nextMonthButtonTapped:(id)sender {
    // show next month
}

- (void)reloadData {
    
}

@end
