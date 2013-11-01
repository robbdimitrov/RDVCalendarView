// RDVCalendarMonthView.h
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

@protocol RDVCalendarMonthViewDelegate;
@class RDVCalendarDayCell;

@interface RDVCalendarMonthView : UIView

@property (weak) id <RDVCalendarMonthViewDelegate> delegate;

@property (nonatomic) RDVCalendarDayCell *selectedDayCell;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (NSInteger)indexForCell:(RDVCalendarDayCell *)cell;
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
