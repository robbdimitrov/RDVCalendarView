//
//  RDVCalendarMonthView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/26/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarMonthView.h"
#import "RDVCalendarDayView.h"
#import <QuartzCore/QuartzCore.h>

@interface RDVCalendarMonthView ()

@property (nonatomic) NSArray *dayViews;

@end

@implementation RDVCalendarMonthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    
    NSInteger column = 0;
    CGFloat dayWidth = roundf(viewSize.width / 7);
    NSInteger row = 0;
    
    for (UIView *dayView in [self dayViews]) {
        [dayView setFrame:CGRectMake(column * dayWidth, row * dayWidth, dayWidth, dayWidth)];
        
        if (column == 6) {
            column = 0;
            row++;
        } else {
            column++;
        }
    }
}

@end
