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

typedef NS_OPTIONS(NSInteger, RDVCalendarViewDayCellSeparatorType) {
    RDVCalendarViewDayCellSeparatorTypeNone        = 0,
    RDVCalendarViewDayCellSeparatorTypeHorizontal  = 1 << 0,
    RDVCalendarViewDayCellSeparatorTypeVertical    = 1 << 2,
    RDVCalendarViewDayCellSeparatorTypeBoth        = (RDVCalendarViewDayCellSeparatorTypeHorizontal |
                                                       RDVCalendarViewDayCellSeparatorTypeVertical),
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
@property (nonatomic) RDVCalendarViewDayCellSeparatorType separatorStyle;

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
 * The inset or outset margins for the rectangle around the separators.
 */
@property (nonatomic) UIEdgeInsets separatorEdgeInsets;

/**
 * The inset or outset margins for the rectangle surrounding the day cells.
 */
@property (nonatomic) UIEdgeInsets dayCellEdgeInsets;

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

/**
 * Date components representing the currently displayed month. (read-only)
 */
@property (atomic, strong, readonly) NSDateComponents *month;

#pragma mark - Creating Calendar View Day Cells

/**
 * Registers a class for use in creating new table cells.
 */
- (void)registerDayCellClass:(Class)cellClass;

/**
 * Returns a reusable calendar-view day cell object located by its identifier.
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

#pragma mark - Accessing Day Cells

/**
 * Returns the table cells that are visible in the receiver.
 */
- (NSArray *)visibleCells;

/**
 * Returns an index representing the position of a given day cell.
 */
- (NSInteger)indexForDayCell:(RDVCalendarDayCell *)cell;

/**
 * Returns an index identifying the position of day cell at the given point.
 */
- (NSInteger)indexForDayCellAtPoint:(CGPoint)point;

/**
 * Returns the day cell at the specified index.
 */
- (RDVCalendarDayCell *)dayCellForIndex:(NSInteger)index;

/**
 * Returns the NSDate at the specified index.
 */
- (NSDate *)dateForIndex:(NSInteger)index;

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

#pragma mark - Navigation

/**
 * Display current month.
 */
- (void)showCurrentMonth;

/**
 * Display previous month.
 */
- (void)showPreviousMonth;

/**
 * Display next month.
 */
- (void)showNextMonth;

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

/**
 * Asks the delegate if the specified date should be selected.
 */
- (BOOL)calendarView:(RDVCalendarView *)calendarView shouldSelectDate:(NSDate *)date;

/**
 * Tells the delegate that a specified date is about to be selected.
 */
- (void)calendarView:(RDVCalendarView *)calendarView willSelectDate:(NSDate *)date;

/**
 * Tells the delegate that the specified date is now selected.
 */
- (void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date;

/**
 * Tells the delegate that the currently displayed month has changed.
 * @param month The newly selected month.
 */
- (void)calendarView:(RDVCalendarView *)calendarView didChangeMonth:(NSDateComponents *)month;

#pragma mark - Customization

/**
 * Asks the delegate for the height to use for day cells.
 */
- (CGFloat)heightForDayCellInCalendarView:(RDVCalendarView *)calendarView;

/**
 * Asks the delegate for the width to use for day cells.
 */
- (CGFloat)widthForDayCellInCalendarView:(RDVCalendarView *)calendarView;

/**
 * Asks the delegate for additional customization of the day cell.
 */
- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index;

@end
