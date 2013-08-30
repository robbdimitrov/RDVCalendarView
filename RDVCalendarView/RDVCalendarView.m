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
#import <QuartzCore/QuartzCore.h>

@interface RDVCalendarView () <RDVCalendarMonthViewDelegate>

@property (nonatomic) RDVCalendarWeekDaysHeader *weekDaysView;
@property (nonatomic) RDVCalendarMonthView *monthView;

@property NSDateComponents *selectedDay;
@property NSDateComponents *month;
@property NSDateComponents *currentDay;
@property NSDate *firstDay;

@end

@implementation RDVCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _normalDayColor = [UIColor whiteColor];
        _selectedDayColor = [UIColor grayColor];
        _currentDayColor = [UIColor lightGrayColor];
        
        _dayTextColor = [UIColor blackColor];
        _highlightedDayTextColor = [UIColor whiteColor];
        
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        
        _currentDay = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
        
        NSDate *currentDate = [NSDate date];
        
        [self setupViews];
        
        _month = [calendar components:NSYearCalendarUnit|
                                      NSMonthCalendarUnit|
                                      NSDayCalendarUnit|
                                      NSWeekdayCalendarUnit|
                                      NSCalendarCalendarUnit
                             fromDate:currentDate];
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
    
    CGSize monthViewSize = [[self monthView] sizeThatFits:CGSizeMake(viewSize.width, viewSize.height -
                                                                     CGRectGetMaxY([self weekDaysView].frame))];
    [[self monthView] setFrame:CGRectMake(0, CGRectGetMaxY([self weekDaysView].frame), monthViewSize.width, monthViewSize.height)];
}

- (void)setupViews {
    _headerView = [[RDVCalendarHeaderView alloc] init];
    [[_headerView backButton] addTarget:self action:@selector(previousMonthButtonTapped:)
                       forControlEvents:UIControlEventTouchUpInside];
    [[_headerView forwardButton] addTarget:self action:@selector(nextMonthButtonTapped:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_headerView];
    
    _weekDaysView = [[RDVCalendarWeekDaysHeader alloc] init];
    [self addSubview:_weekDaysView];
    
    _monthView = [[RDVCalendarMonthView alloc] init];
    [_monthView setDelegate:self];
    [self addSubview:_monthView];
}

- (void)previousMonthButtonTapped:(id)sender {
    NSInteger month = [[self month] month] - 1;
    [[self month] setMonth:month];
    
    [self updateMonthLabelMonth:[self month]];
    [self updateMonthViewMonth:[self month]];
}

- (void)nextMonthButtonTapped:(id)sender {
    NSInteger month = [[self month] month] + 1;
    [[self month] setMonth:month];
    
    [self updateMonthLabelMonth:[self month]];
    [self updateMonthViewMonth:[self month]];
}

- (void)reloadData {
    [[self monthView] reloadData];
}

- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM yyyy";
    
    NSDate *date = [month.calendar dateFromComponents:month];
    self.headerView.titleLabel.text = [formatter stringFromDate:date];
    
    [[self headerView] setNeedsLayout];
}

- (void)updateMonthViewMonth:(NSDateComponents *)month {
    [self setFirstDay:[month.calendar dateFromComponents:month]];
    [[self monthView] reloadData];
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    NSDate *oldDate = [self selectedDate];
    
    if (![oldDate isEqualToDate:selectedDate]) {
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        
        if (![self selectedDay]) {
            [self setSelectedDay:[[NSDateComponents alloc] init]];
        }
        
        NSDateComponents *selectedDateComponents = [calendar components:NSYearCalendarUnit|
                                                                        NSMonthCalendarUnit|
                                                                        NSDayCalendarUnit
                                                               fromDate:selectedDate];
        
        [[self selectedDay] setMonth:[selectedDateComponents month]];
        [[self selectedDay] setYear:[selectedDateComponents year]];
        [[self selectedDay] setDay:[selectedDateComponents day]];
        
        self.month = [calendar components:NSYearCalendarUnit|
                                          NSMonthCalendarUnit|
                                          NSDayCalendarUnit|
                                          NSWeekdayCalendarUnit|
                                          NSCalendarCalendarUnit
                                 fromDate:selectedDate];
        self.month.day = 1;
        [self updateMonthLabelMonth:self.month];
        
        [self updateMonthViewMonth:self.month];
    }
}

- (NSDate *)selectedDate {
    return [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:[self selectedDay]];
}

#pragma mark - RDVCalendarMonthViewDelegate

- (RDVCalendarDayCell *)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView dayCellForIndex:(NSInteger)index {
    static NSString *DayIdentifier = @"Day";
    
    RDVCalendarDayCell *dayCell = [calendarMonthView dequeueReusableCellWithIdentifier:DayIdentifier];
    if (!dayCell) {
        dayCell = [[RDVCalendarDayCell alloc] initWithStyle:RDVCalendarDayCellSelectionStyleNormal reuseIdentifier:DayIdentifier];
        [[dayCell titleLabel] setTextColor:[self dayTextColor]];
        [[dayCell titleLabel] setHighlightedTextColor:[self highlightedDayTextColor]];
    }
    
    [dayCell.titleLabel setText:[NSString stringWithFormat:@"%d", index + 1]];
    
    if (index + 1 == [self currentDay].day &&
        [self month].month == [self currentDay].month &&
        [self month].year == [self currentDay].year) {
            [[dayCell backgroundView] setBackgroundColor:[self currentDayColor]];
    } else {
        [[dayCell backgroundView] setBackgroundColor:[self normalDayColor]];
    }
    
    [[dayCell selectedBackgroundView] setBackgroundColor:[self selectedDayColor]];
    
    if ([self selectedDay] && (index + 1 == [self selectedDay].day &&
        [self month].month == [self selectedDay].month &&
        [self month].year == [self selectedDay].year)) {
        
        [dayCell setSelected:YES animated:NO];
        [[self monthView] setSelectedDayCell:dayCell];
    }
    
    return dayCell;
}

- (void)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView didSelectDayCellAtIndex:(NSInteger)index {
    if (![self selectedDay]) {
        [self setSelectedDay:[[NSDateComponents alloc] init]];
    }
    
    [[self selectedDay] setMonth:[[self month] month]];
    [[self selectedDay] setYear:[[self month] year]];
    [[self selectedDay] setDay:index + 1];
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:self didSelectDate:[self selectedDate]];
    }
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
