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

@class RDVCalendarDayCell;

typedef NS_ENUM(NSInteger, RDVCalendarViewDayCellSeparatorType) {
    RDVCalendarViewDayCellSeparatorStyleNone,
    RDVCalendarViewDayCellSeparatorStyleHorizontal,
};

@protocol RDVCalendarViewDelegate;

@interface RDVCalendarView : UIView

#pragma mark - Managing the Delegate

/**
 * The object that acts as the delegate of the receiving calendar view.
 */
@property (weak) id <RDVCalendarViewDelegate> delegate;

#pragma mark - Configuring a Calendar View

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

/**
 * Returns array containing the week day labels.
 */
@property (nonatomic, readonly) NSArray *weekDayLabels;

/**
 * Returns the height for week day elements.
 */
@property (nonatomic) CGFloat weekDayHeight;

/**
 * The style for separators used between day cells.
 */
@property(nonatomic) RDVCalendarViewDayCellSeparatorType separatorStyle;

/**
 * Returs the color of the current day cell.
 */
@property (nonatomic) UIColor *currentDayColor;

/**
 * Returs the color of normal day cell.
 */
@property (nonatomic) UIColor *normalDayColor;

/**
 * Returs the color of the selected day cell.
 */
@property (nonatomic) UIColor *selectedDayColor;

/**
 * The color of separators in the calendar view.
 */
@property(nonatomic, retain) UIColor *separatorColor;

/**
 * Returns the currently selected date.
 */
@property (nonatomic) NSDate *selectedDate;

/**
 * The width of each day cell in the receiver.
 */
@property(nonatomic) CGFloat dayCellWidth;

/**
 * The height of each day cell in the receiver.
 */
@property(nonatomic) CGFloat dayCellHeight;

#pragma mark - Creating Calendar View Day Cells

/**
 * Registers a class for use in creating new table cells.
 */
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

/**
 * Returns a reusable calendar-view day cell object located by its identifier.
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

#pragma mark - Accessing Cells

/**
 * Returns the table cells that are visible in the receiver.
 */
- (NSArray *)visibleCells;

- (NSInteger)indexForCell:(RDVCalendarDayCell *)cell;

- (NSInteger)indexForRowAtPoint:(CGPoint)point;

- (RDVCalendarDayCell *)dayCellForRowAtIndex:(NSInteger)index;

#pragma mark - Managing Selections

/**
 * Returns an index identifying the selected day cell.
 */
- (NSInteger)indexForSelectedDayCell;

/**
 * Selects a day cell in the receiver identified by index.
 */
- (void)selectDayCellAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 * Deselects a given day cell identified by index, with an option to animate the deselection.
 */
- (void)deselectDayCellAtIndex:(NSInteger)index animated:(BOOL)animated;

#pragma mark - Reloading the Calendar view

/**
 * Reloads the cells of the receiver.
 */
- (void)reloadData;

@end

@protocol RDVCalendarViewDelegate <NSObject>
@optional
#pragma mark - Managing Selections

/**
 * Asks the delegate if the specified day cell should be selected.
 */
- (BOOL)calendarView:(RDVCalendarView *)calendarView shouldSelectCellAtIndex:(NSInteger)index;

/**
 * Tells the delegate that a specified day cell is about to be selected.
 */
- (void)calendarView:(RDVCalendarView *)calendarView willSelectCellAtIndex:(NSInteger)index;

/**
 * Tells the delegate that the specified row is now selected.
 */
- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index;
@end
