// RDVCalendarDayCell.h
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

typedef NS_ENUM(NSInteger, RDVCalendarDayCellSelectionStyle) {
    RDVCalendarDayCellSelectionStyleNone,
    RDVCalendarDayCellSelectionStyleDefault,
};

@interface RDVCalendarDayCell : UIView

/**
 * A string used to identify a day cell that is reusable. (read-only)
 */
@property(nonatomic, readonly, copy) NSString *reuseIdentifier;

/**
 * Returns the label used for the main textual content of the day cell. (read-only)
 */
@property (nonatomic, readonly) UILabel *textLabel;

/**
 * Returns the content view of the day cell object. (read-only)
 */
@property (nonatomic, readonly) UIView *contentView;

/**
 * The view used as the background of the day cell.
 */
@property (nonatomic, strong) UIView *backgroundView;

/**
 * The view used as the background of the day cell when it is selected.
 */
@property (nonatomic, strong) UIView *selectedBackgroundView;

/**
 * The style of selection for a cell.
 */
@property(nonatomic) RDVCalendarDayCellSelectionStyle selectionStyle;

/**
 * A Boolean value that indicates whether the cell is selected.
 */
@property(nonatomic, getter = isSelected) BOOL selected;

/**
 * A Boolean value that indicates whether the cell is highlighted.
 */
@property(nonatomic, getter = isHighlighted) BOOL highlighted;

/**
 * Initializes a day cell with a reuse identifier and returns it to the caller.
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 * Sets the selected state of the cell, optionally animating the transition between states.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/**
 * Sets the highlighted state of the cell, optionally animating the transition between states.
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

/**
 * Prepares a reusable day cell for reuse by the calendar view.
 */
- (void)prepareForReuse;

@end
