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
        
        _backButton = [[UIButton alloc] init];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_backButton setTitle:@"Prev" forState:UIControlStateNormal];
        [self addSubview:_backButton];
        
        _forwardButton = [[UIButton alloc] init];
        [_forwardButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_forwardButton setTitle:@"Next" forState:UIControlStateNormal];
        [self addSubview:_forwardButton];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    
    CGSize previousMonthButtonSize = [[self backButton] sizeThatFits:CGSizeMake(100, 50)];
    CGSize nextMonthButtonSize = [[self forwardButton] sizeThatFits:CGSizeMake(100, 50)];
    CGSize titleSize = [[self titleLabel] sizeThatFits:CGSizeMake(viewSize.width - previousMonthButtonSize.width -
                                                                  nextMonthButtonSize.width, 50)];
    
    [self.backButton setFrame:CGRectMake(10, roundf(viewSize.height / 2 - previousMonthButtonSize.height / 2),
                                                  previousMonthButtonSize.width, previousMonthButtonSize.height)];
    
    [self.titleLabel setFrame:CGRectMake(roundf(viewSize.width / 2 - titleSize.width / 2),
                                         roundf(viewSize.height / 2 - titleSize.height / 2),
                                         titleSize.width, titleSize.height)];
    
    [self.forwardButton setFrame:CGRectMake(viewSize.width - 10 - nextMonthButtonSize.width,
                                              roundf(viewSize.height / 2 - nextMonthButtonSize.height / 2),
                                              nextMonthButtonSize.width, nextMonthButtonSize.height)];
}

@end
