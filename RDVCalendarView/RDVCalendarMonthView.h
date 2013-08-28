//
//  RDVCalendarMonthView.h
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/26/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RDVCalendarMonthViewDelegate;
@class RDVCalendarDayCell;

@interface RDVCalendarMonthView : UIView

@property (weak) id <RDVCalendarMonthViewDelegate> delegate;
@property (nonatomic) NSInteger selectedIndex;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (NSInteger)indexForCell:(UITableViewCell *)cell;
- (NSInteger)indexForRowAtPoint:(CGPoint)point;
- (RDVCalendarDayCell *)cellForRowAtIndex:(NSInteger)index;
- (NSInteger)indexForSelectedCell;

- (void)reloadData;

@end

@protocol RDVCalendarMonthViewDelegate <NSObject>
- (NSInteger)numberOfWeeksInCalendarMonthView:(RDVCalendarMonthView *)calendarMonthView;
- (NSInteger)numberOfDaysInCalendarMonthView:(RDVCalendarMonthView *)calendarMonthView;
- (NSInteger)numberOfDaysInFirstWeek:(RDVCalendarMonthView *)calendarMonthView;
- (RDVCalendarDayCell *)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView dayCellForIndex:(NSInteger)index;

@optional
- (BOOL)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView shouldSelectDayCellAtIndex:(NSInteger)index;
- (void)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView willSelectDayCellAtIndex:(NSInteger)index;
- (void)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView didSelectDayCellAtIndex:(NSInteger)index;
@end
