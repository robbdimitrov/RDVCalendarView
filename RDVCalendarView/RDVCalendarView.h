// RDVCalendarView.h
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "RDVCalendarMonthView.h"
#import "RDVCalendarDayCell.h"
#import "RDVCalendarWeekDaysHeader.h"

@class RDVCalendarHeaderView;

@protocol RDVCalendarViewDelegate;

@interface RDVCalendarView : UIView <RDVCalendarMonthViewDelegate>

@property (weak) id <RDVCalendarViewDelegate> delegate;

/**
 * Returns the label, which contains the name of the currently displayed month. (read-only)
 */
@property (nonatomic, readonly) UILabel *monthLabel;

/**
 * Returns the back (previous month) button. (read-only)
 */
@property (nonatomic, readonly) UIButton *backButton;

/**
 * Returns the forward (next month) button. (read-only)
 */
@property (nonatomic, readonly) UIButton *forwardButton;

@property (nonatomic) RDVCalendarWeekDaysHeader *weekDaysView;
@property (nonatomic) RDVCalendarMonthView *monthView;

@property (nonatomic) UIColor *currentDayColor;
@property (nonatomic) UIColor *normalDayColor;
@property (nonatomic) UIColor *selectedDayColor;

@property (nonatomic) UIColor *dayTextColor;
@property (nonatomic) UIColor *highlightedDayTextColor;

@property (nonatomic) NSDate *selectedDate;

- (void)reloadData;

@end

@protocol RDVCalendarViewDelegate <NSObject>
@optional
- (BOOL)calendarView:(RDVCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
- (void)calendarView:(RDVCalendarView *)calendarView willSelectDate:(NSDate *)date;
- (void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date;
@end
