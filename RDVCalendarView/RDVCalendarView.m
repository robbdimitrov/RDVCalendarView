//
//  RDVCalendarView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarView.h"
#import "RDVCalendarDayView.h"
#import "RDVCalendarWeekDaysView.h"
#import "RDVCalendarHeaderView.h"
#import "RDVCalendarMonthView.h"

@interface RDVCalendarView ()

@property (nonatomic) RDVCalendarWeekDaysView *weekDaysView;
@property (nonatomic) RDVCalendarMonthView *monthView;
@property NSCalendar *calendar;

@end

@implementation RDVCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _calendar = [NSCalendar autoupdatingCurrentCalendar];
        _selectedDate = [NSDate date];
        
        NSLog(@"calendar.firstWeekday = %d", _calendar.firstWeekday);
        NSLog(@"caledar.minimumDaysInFirstWeek = %d", _calendar.minimumDaysInFirstWeek);
        
        _headerView = [[RDVCalendarHeaderView alloc] init];
        [[_headerView titleLabel] setText:@"August"];
        [self addSubview:_headerView];
        
        _weekDaysView = [[RDVCalendarWeekDaysView alloc] init];
        [_weekDaysView setWeekDays:@[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"]];
        [self addSubview:_weekDaysView];
        
        _monthView = [[RDVCalendarMonthView alloc] init];
        [self addSubview:_monthView];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewSize = CGSizeMake(CGRectGetHeight(self.frame), CGRectGetWidth(self.frame));
    }
    
    [[self headerView] setFrame:CGRectMake(0, 0, viewSize.width, 60)];
    
    [[self weekDaysView] setFrame:CGRectMake(0, CGRectGetMaxY([self headerView].frame), viewSize.width, 30)];
    
    [[self monthView] setFrame:CGRectMake(0, CGRectGetMaxY([self weekDaysView].frame), viewSize.width, 500)];
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
