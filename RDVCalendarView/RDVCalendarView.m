//
//  RDVCalendarView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarView.h"
#import "RDVCalendarDayView.h"
#import <QuartzCore/QuartzCore.h>

@interface RDVCalendarView ()

@property (nonatomic) NSArray *weekDayViews;
@property (nonatomic) NSArray *dayViews;

@end

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
        
        NSArray *weekDays = @[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
        NSMutableArray *weekDayViews = [[NSMutableArray alloc] initWithCapacity:7];
        
        for (NSString *weekDay in weekDays) {
            UILabel *weekDayView = [[UILabel alloc] init];
            [weekDayView setBackgroundColor:[UIColor clearColor]];
            [weekDayView setText:weekDay];
            [weekDayView setTextColor:[UIColor grayColor]];
            [weekDayView setFont:[UIFont systemFontOfSize:18]];
            [weekDayView setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:weekDayView];
            [weekDayViews addObject:weekDayView];
        }
        
        _weekDayViews = [[NSArray alloc] initWithArray:weekDayViews];
        
        NSMutableArray *dayViews = [[NSMutableArray alloc] initWithCapacity:30];
        
        for (NSInteger i = 0; i < 30; i++) {
            RDVCalendarDayView *dayView = [[RDVCalendarDayView alloc] init];
            [dayView.titleLabel setText:[NSString stringWithFormat:@"%d", i + 1]];
            [dayView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [dayView setBackgroundColor:[UIColor whiteColor]];
            [dayView.layer setBorderWidth:2.0];
            [self addSubview:dayView];
            [dayViews addObject:dayView];
        }
        
        _dayViews = [[NSArray alloc] initWithArray:dayViews];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewSize = CGSizeMake(CGRectGetHeight(self.frame), CGRectGetWidth(self.frame));
    }
    
    CGSize previousMonthButtonSize = [_previousMonthButton sizeThatFits:CGSizeMake(100, 50)];
    CGSize nextMonthButtonSize = [_nextMonthButton sizeThatFits:CGSizeMake(100, 50)];
    CGSize titleSize = [_titleView sizeThatFits:CGSizeMake(viewSize.width - previousMonthButtonSize.width - nextMonthButtonSize.width, 50)];
    
    [_previousMonthButton setFrame:CGRectMake(10, 20, previousMonthButtonSize.width, previousMonthButtonSize.height)];
    [_titleView setFrame:CGRectMake(roundf(viewSize.width / 2 - titleSize.width / 2),
                                    18, titleSize.width, titleSize.height)];
    
    [_nextMonthButton setFrame:CGRectMake(viewSize.width - 10 - nextMonthButtonSize.width, 20, nextMonthButtonSize.width, nextMonthButtonSize.height)];
    
    NSInteger row = 0;
    NSInteger column = 0;
    CGFloat dayWidth = roundf(viewSize.width / 7);
    CGFloat calendarStartingY = CGRectGetMaxY(_titleView.frame) + 20;
    
    for (UIView *weekDayView in [self weekDayViews]) {
        [weekDayView setFrame:CGRectMake(column * dayWidth, calendarStartingY + row * dayWidth, dayWidth, dayWidth)];
        
        column++;
    }
    
    column = 0;
    calendarStartingY += dayWidth;
    
    for (UIView *dayView in [self dayViews]) {
        [dayView setFrame:CGRectMake(column * dayWidth, calendarStartingY + row * dayWidth, dayWidth, dayWidth)];
        
        if (column == 6) {
            column = 0;
            row++;
        } else {
            column++;
        }
    }
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
