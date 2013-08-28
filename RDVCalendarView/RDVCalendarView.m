//
//  RDVCalendarView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarView.h"
#import "RDVCalendarDayCell.h"
#import "RDVCalendarWeekDaysHeader.h"
#import "RDVCalendarHeaderView.h"
#import "RDVCalendarMonthView.h"

@interface RDVCalendarView () <RDVCalendarMonthViewDelegate>

@property (nonatomic) RDVCalendarWeekDaysHeader *weekDaysView;
@property (nonatomic) RDVCalendarMonthView *monthView;

@property NSDateComponents *month;
@property NSDate *firstDay;

@end

@implementation RDVCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedDate = [NSDate date];
        
        [self setupViews];
        
        _month = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|
                                                          NSMonthCalendarUnit|
                                                          NSDayCalendarUnit|
                                                          NSWeekdayCalendarUnit|
                                                          NSCalendarCalendarUnit
                                                 fromDate:_selectedDate];
        _month.day = 1;
        [self updateMonthLabelMonth:_month];
        
        [self updateMonthViewMonth:_month];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(currentLocaleDidChange:)
                                                     name:NSCurrentLocaleDidChangeNotification
                                                   object:nil];
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

- (void)setupViews {
    _headerView = [[RDVCalendarHeaderView alloc] init];
    [self addSubview:_headerView];
    
    _weekDaysView = [[RDVCalendarWeekDaysHeader alloc] init];
    [self addSubview:_weekDaysView];
    
    _monthView = [[RDVCalendarMonthView alloc] init];
    [_monthView setDelegate:self];
    [self addSubview:_monthView];
}

- (void)previousMonthButtonTapped:(id)sender {
    // show previous month
}

- (void)nextMonthButtonTapped:(id)sender {
    // show next month
}

- (void)reloadData {
    [[self monthView] reloadData];
}

- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM yyyy";
    
    NSDate *date = [month.calendar dateFromComponents:month];
    self.headerView.titleLabel.text = [formatter stringFromDate:date];
}

- (void)updateMonthViewMonth:(NSDateComponents *)month {
    [self setFirstDay:[month.calendar dateFromComponents:month]];
}

#pragma mark - RDVCalendarMonthViewDelegate

- (RDVCalendarDayCell *)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView dayCellForIndex:(NSInteger)index {
    static NSString *DayIdentifier = @"Day";
    
    RDVCalendarDayCell *dayCell = [calendarMonthView dequeueReusableCellWithIdentifier:DayIdentifier];
    if (!dayCell) {
        dayCell = [[RDVCalendarDayCell alloc] initWithStyle:RDVCalendarDayCellSelectionStyleNormal reuseIdentifier:DayIdentifier];
        [dayCell.titleLabel setText:[NSString stringWithFormat:@"%d", index + 1]];
    }
    
    return dayCell;
}

- (void)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView didSelectIndex:(NSInteger)index {
    
}

- (NSInteger)numberOfWeeksInCalendarMonthView:(RDVCalendarMonthView *)calendarMonthView {
    return [self.month.calendar rangeOfUnit:NSDayCalendarUnit
                                     inUnit:NSWeekCalendarUnit
                                    forDate:[self firstDay]].length;
}

- (NSInteger)numberOfDaysInCalendarMonthView:(RDVCalendarMonthView *)calendarMonthView {
    return [self.month.calendar rangeOfUnit:NSDayCalendarUnit
                                     inUnit:NSMonthCalendarUnit
                                    forDate:[self firstDay]].length;
}

- (NSInteger)numberOfDaysInFirstWeek:(RDVCalendarMonthView *)calendarMonthView {
    return [self.month.calendar rangeOfUnit:NSDayCalendarUnit
                                     inUnit:NSWeekCalendarUnit
                                    forDate:[self firstDay]].length;
}

- (void)currentLocaleDidChange:(NSNotification *)notification {
    [[self weekDaysView] setupWeekDays];
    [self updateMonthLabelMonth:[self month]];
}

@end
