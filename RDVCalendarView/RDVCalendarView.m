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
@property NSCalendar *calendar;

@end

@implementation RDVCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _calendar = [NSCalendar autoupdatingCurrentCalendar];
        _selectedDate = [NSDate date];
        
        _headerView = [[RDVCalendarHeaderView alloc] init];
        [[_headerView titleLabel] setText:@"August"];
        [self addSubview:_headerView];
        
        _weekDaysView = [[RDVCalendarWeekDaysHeader alloc] init];
        [self addSubview:_weekDaysView];
        
        _monthView = [[RDVCalendarMonthView alloc] init];
        [self addSubview:_monthView];
        
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

- (void)previousMonthButtonTapped:(id)sender {
    // show previous month
}

- (void)nextMonthButtonTapped:(id)sender {
    // show next month
}

- (void)reloadData {
    
}

#pragma mark - RDVCalendarMonthViewDelegate

- (RDVCalendarDayCell *)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView dayForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DayIdentifier = @"Day";
    
    RDVCalendarDayCell *dayCell = [calendarMonthView dequeueReusableCellWithIdentifier:DayIdentifier];
    if (!dayCell) {
        dayCell = [[RDVCalendarDayCell alloc] initWithStyle:RDVCalendarDayCellSelectionStyleNormal reuseIdentifier:DayIdentifier];
        [dayCell.titleLabel setText:[NSString stringWithFormat:@"%d", indexPath.row + indexPath.section]];
    }
    
    return dayCell;
}

- (void)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView didSelectIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)numberOfWeeksInCalendarMonthView:(RDVCalendarMonthView *)calendarMonthView {
    return 0;
}

- (void)currentLocaleDidChange:(NSNotification *)notification {
    [[self weekDaysView] setupWeekDays];
}

@end
