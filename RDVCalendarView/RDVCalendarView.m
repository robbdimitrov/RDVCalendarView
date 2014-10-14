// RDVCalendarView.m
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

#import "RDVCalendarView.h"
#import "RDVCalendarDayCell.h"

@interface RDVCalendarView () {
    NSMutableArray *_visibleCells;
    NSMutableArray *_dayCells;
    
    NSInteger _numberOfDays;
    NSInteger _numberOfWeeks;
    
    NSMutableArray *_separators;
    NSMutableArray *_visibleSeparators;
    
    RDVCalendarDayCell *_selectedDayCell;
    
    NSArray *_weekDays;
    
    Class _dayCellClass;
    
    UIInterfaceOrientation _orientation;
}

@property (atomic, strong) NSDateComponents *selectedDay;
@property (atomic, strong, readwrite) NSDateComponents *month;
@property (atomic, strong) NSDateComponents *currentDay;
@property (atomic, strong) NSDate *firstDay;

@end

@implementation RDVCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dayCells = [[NSMutableArray alloc] initWithCapacity:31];
        _visibleCells = [[NSMutableArray alloc] initWithCapacity:31];
        
        _visibleSeparators = [[NSMutableArray alloc] initWithCapacity:12];
        _separators = [[NSMutableArray alloc] initWithCapacity:12];
        
        // Setup defaults
        
        _currentDayColor = [UIColor colorWithRed:80/255.0 green:200/255.0 blue:240/255.0 alpha:1.0];
        _selectedDayColor = [UIColor grayColor];
        _separatorColor = [UIColor lightGrayColor];
        
        _separatorEdgeInsets = UIEdgeInsetsZero;
        _dayCellEdgeInsets = UIEdgeInsetsZero;
        
        _dayCellClass = [RDVCalendarDayCell class];
        
        _weekDayHeight = 30.0f;
        
        // Setup header view
        
        _monthLabel = [[UILabel alloc] init];
        [_monthLabel setFont:[UIFont systemFontOfSize:22]];
        [_monthLabel setTextColor:[UIColor blackColor]];
        [_monthLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_monthLabel];
        
        _backButton = [[UIButton alloc] init];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_backButton setTitle:@"Prev" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(showPreviousMonth)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        _forwardButton = [[UIButton alloc] init];
        [_forwardButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_forwardButton setTitle:@"Next" forState:UIControlStateNormal];
        [_forwardButton addTarget:self action:@selector(showNextMonth)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_forwardButton];
        
        [self setupWeekDays];
        
        // Setup calendar
        
        NSCalendar *calendar = [self calendar];
        
        _currentDay = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
        
        NSDate *currentDate = [NSDate date];
        
        _month = [calendar components:NSYearCalendarUnit|
                                      NSMonthCalendarUnit|
                                      NSDayCalendarUnit|
                                      NSWeekdayCalendarUnit|
                                      NSCalendarCalendarUnit
                             fromDate:currentDate];
        _month.day = 1;
        
        [self updateMonthLabelMonth:_month];
        
        [self updateMonthViewMonth:_month];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        [defaultCenter addObserver:self
                         selector:@selector(currentLocaleDidChange:)
                             name:NSCurrentLocaleDidChangeNotification
                           object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(deviceDidChangeOrientation:)
                              name:UIDeviceOrientationDidChangeNotification
                            object:nil];
        
        _orientation = [[UIApplication sharedApplication] statusBarOrientation];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    CGSize headerSize = CGSizeMake(viewSize.width, 60.0f);
    CGFloat backButtonWidth = MAX([[self backButton] sizeThatFits:CGSizeMake(100, 50)].width, 44);
    CGFloat forwardButtonWidth = MAX([[self forwardButton] sizeThatFits:CGSizeMake(100, 50)].width, 44);
    
    CGSize previousMonthButtonSize = CGSizeMake(backButtonWidth, 50);
    CGSize nextMonthButtonSize = CGSizeMake(forwardButtonWidth, 50);
    CGSize titleSize = CGSizeMake(viewSize.width - previousMonthButtonSize.width - nextMonthButtonSize.width - 10 - 10,
                                  50);
    
    // Layout header view
    
    [[self backButton] setFrame:CGRectMake(10, roundf(headerSize.height / 2 - previousMonthButtonSize.height / 2),
                                         previousMonthButtonSize.width, previousMonthButtonSize.height)];
    
    [[self monthLabel] setFrame:CGRectMake(roundf(headerSize.width / 2 - titleSize.width / 2),
                                         roundf(headerSize.height / 2 - titleSize.height / 2),
                                         titleSize.width, titleSize.height)];
    
    [[self forwardButton] setFrame:CGRectMake(headerSize.width - 10 - nextMonthButtonSize.width,
                                            roundf(headerSize.height / 2 - nextMonthButtonSize.height / 2),
                                            nextMonthButtonSize.width, nextMonthButtonSize.height)];
    
    // Calculate sizes and distances
    
    CGFloat rowCount = 6; // 6 is the maximum number of weeks in a month
    
    CGFloat dayWidth = 0;
    if ([[self delegate] respondsToSelector:@selector(widthForDayCellInCalendarView:)]) {
        dayWidth = [[self delegate] widthForDayCellInCalendarView:self];
    } else if ([self dayCellWidth]) {
        dayWidth = [self dayCellWidth];
    } else {
        if (viewSize.width > viewSize.height) {
            dayWidth = roundf(viewSize.width / 10);
        } else {
            dayWidth = roundf(viewSize.width / 7);
        }
    }
    
    CGFloat weekDayLabelsEndY = CGRectGetMaxY([[self monthLabel] frame]) + [self weekDayHeight];
    
    CGFloat dayHeight = 0;
    if ([[self delegate] respondsToSelector:@selector(heightForDayCellInCalendarView:)]) {
        dayHeight = [[self delegate] heightForDayCellInCalendarView:self];
    } else if ([self dayCellHeight]) {
        dayHeight = [self dayCellHeight];
    } else {
        if (viewSize.width > viewSize.height) {
            dayHeight = roundf((viewSize.height - weekDayLabelsEndY) / 6) -
            [self dayCellEdgeInsets].top - [self dayCellEdgeInsets].bottom;
        } else {
            dayHeight = dayWidth;
        }
    }
    
    CGFloat elementHorizonralDistance = roundf((viewSize.width - [self dayCellEdgeInsets].left -
                                        [self dayCellEdgeInsets].right - dayWidth * 7) / 6);
    
    // Week days layout
    
    NSInteger column = 0;
    for (UILabel *weekDayLabel in [self weekDayLabels]) {
        CGFloat labelXPosition = [self dayCellEdgeInsets].left + (column * dayWidth) + (column * elementHorizonralDistance);
        [weekDayLabel setFrame:CGRectMake(labelXPosition, CGRectGetMaxY([[self monthLabel] frame]), dayWidth, [self weekDayHeight])];
        column++;
    }
    
    // Calendar grid layout
    
    CGFloat startigCalendarY = CGRectGetMaxY([[self weekDayLabels][0] frame]);
    CGFloat elementVerticalDistance = round(((viewSize.height - startigCalendarY) - [self dayCellEdgeInsets].top -
                                             [self dayCellEdgeInsets].bottom - (dayHeight * rowCount)) / rowCount);
    
    column = 7 - [self numberOfDaysInFirstWeek];
    
    NSInteger row = 0;
    
    for (NSInteger dayIndex = 0; dayIndex < [self numberOfDays]; dayIndex++) {
        RDVCalendarDayCell *dayCell = [self dayCellForIndex:dayIndex];
        if (![[self visibleCells] containsObject:dayCell]) {
            [_visibleCells addObject:dayCell];
            [self addSubview:dayCell];
        }
        
        if ([self selectedDay] && (dayIndex + 1 == [self selectedDay].day &&
                                   [self month].month == [self selectedDay].month &&
                                   [self month].year == [self selectedDay].year)) {
            
            [dayCell setSelected:YES animated:NO];
            _selectedDayCell = dayCell;
        }
        
        if ([[self delegate] respondsToSelector:@selector(calendarView:configureDayCell:atIndex:)]) {
            [[self delegate] calendarView:self configureDayCell:dayCell atIndex:dayIndex];
        }
        
        CGFloat dayCellXPosition = [self dayCellEdgeInsets].left + (column * dayWidth) + (column * elementHorizonralDistance);
        CGFloat dayCellYPosition = [self dayCellEdgeInsets].top + (row * dayHeight) + (row * elementVerticalDistance);
        
        [dayCell setFrame:CGRectMake(dayCellXPosition, startigCalendarY + dayCellYPosition, dayWidth, dayHeight)];
        
        if ([dayCell superview] != self) {
            [self addSubview:dayCell];
        }
        
        // Layout separators
        
        if (dayIndex == 0 || column == 0) {
            if ([self separatorStyle] & RDVCalendarViewDayCellSeparatorTypeHorizontal) {
                if (dayIndex < [self numberOfDays]) {
                    UIView *separator = [self dayCellSeparator];
                    
                    [separator setFrame:CGRectMake([self separatorEdgeInsets].left, CGRectGetMinY(dayCell.frame) +
                                                   ([self separatorEdgeInsets].top - [self separatorEdgeInsets].bottom),
                                                   viewSize.width - [self separatorEdgeInsets].left -
                                                   [self separatorEdgeInsets].right, 1)];
                }
            }
        }
        
        if (row == 1 && column < [[self weekDayLabels] count]) {
            if ([self separatorStyle] & RDVCalendarViewDayCellSeparatorTypeVertical) {
                UIView *separator = [self dayCellSeparator];
                
                [separator setFrame:CGRectMake([self separatorEdgeInsets].left + CGRectGetMaxX(dayCell.frame) +
                                               roundf(elementHorizonralDistance / 2),
                                               weekDayLabelsEndY + ([self separatorEdgeInsets].top -
                                                                               [self separatorEdgeInsets].bottom),
                                               1, viewSize.height - [self separatorEdgeInsets].top -
                                               [self separatorEdgeInsets].bottom)];
            }
        }
        
        if (column == 6) {
            column = 0;
            
            row++;
        } else {
            column++;
        }
    }
}

#pragma mark - Creating Calendar View Day Cells

- (void)registerDayCellClass:(Class)cellClass {
    _dayCellClass = cellClass;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    UIView *dayCell = nil;
    
    for (RDVCalendarDayCell *calendarDayCell in _dayCells) {
        if ([[calendarDayCell reuseIdentifier] isEqualToString:identifier]) {
            dayCell = calendarDayCell;
            break;
        }
    }
    
    if (dayCell) {
        [_dayCells removeObject:dayCell];
    }
    
    return dayCell;
}

#pragma mark - Set up a calendar view

- (NSCalendar *)calendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar autoupdatingCurrentCalendar];
    });
    return calendar;
}

- (void)setupWeekDays {
    NSCalendar *calendar = [self calendar];
    NSInteger firstWeekDay = [calendar firstWeekday] - 1;
    
    // We need an NSDateFormatter to have access to the localized weekday strings
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSArray *weekSymbols = [formatter shortWeekdaySymbols];
    
    // weekdaySymbols returns and array of strings
    NSMutableArray *weekDays = [[NSMutableArray alloc] initWithCapacity:[weekSymbols count]];
    for (NSInteger day = firstWeekDay; day < [weekSymbols count]; day++) {
        [weekDays addObject:[weekSymbols objectAtIndex:day]];
    }
    
    if (firstWeekDay != 0) {
        for (NSInteger day = 0; day < firstWeekDay; day++) {
            [weekDays addObject:[weekSymbols objectAtIndex:day]];
        }
    }
    
    _weekDays = [NSArray arrayWithArray:weekDays];
    
    if (![_weekDayLabels count]) {
        NSMutableArray *weekDayLabels = [[NSMutableArray alloc] initWithCapacity:[_weekDays count]];
        
        for (NSString *weekDayString in _weekDays) {
            UILabel *weekDayLabel = [[UILabel alloc] init];
            [weekDayLabel setFont:[UIFont systemFontOfSize:14]];
            [weekDayLabel setTextColor:[UIColor grayColor]];
            [weekDayLabel setTextAlignment:NSTextAlignmentCenter];
            [weekDayLabel setText:weekDayString];
            [weekDayLabels addObject:weekDayLabel];
            [self addSubview:weekDayLabel];
        }
        
        _weekDayLabels = [NSArray arrayWithArray:weekDayLabels];
    } else {
        NSInteger index = 0;
        for (NSString *weekDayString in _weekDays) {
            UILabel *weekDayLabel = [self weekDayLabels][index];
            [weekDayLabel setText:weekDayString];
            index++;
        }
    }
}

- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"LLLL yyyy";
    
    NSDate *date = [month.calendar dateFromComponents:month];
    self.monthLabel.text = [formatter stringFromDate:date];
}

- (void)updateMonthViewMonth:(NSDateComponents *)month {
    [self setFirstDay:[month.calendar dateFromComponents:month]];
    [self reloadData];
}

#pragma mark - Reloading the Calendar view

- (void)reloadData {
    for (RDVCalendarDayCell *visibleCell in [self visibleCells]) {
        [visibleCell removeFromSuperview];
        [visibleCell prepareForReuse];
        [_dayCells addObject:visibleCell];
    }
    
    for (UIView *separator in _visibleSeparators) {
        [_separators addObject:separator];
        [separator removeFromSuperview];
    }
    
    [_visibleSeparators removeAllObjects];
    [_visibleCells removeAllObjects];
}

#pragma mark - Separators

- (UIView *)dayCellSeparator {
    UIView *separator = nil;
    if ([_separators count]) {
        separator = [_separators lastObject];
        [_separators removeObject:separator];
        [_visibleSeparators addObject:separator];
    } else {
        separator = [[UIView alloc] init];
        [_visibleSeparators addObject:separator];
    }
    
    [separator setBackgroundColor:[self separatorColor]];
    
    if ([separator superview] != self) {
        [self addSubview:separator];
    }
    
    return separator;
}

#pragma mark - Date selection

- (void)setSelectedDate:(NSDate *)selectedDate {
    NSDate *oldDate = [self selectedDate];
    
    if (![oldDate isEqualToDate:selectedDate]) {
        NSCalendar *calendar = [self calendar];
       
        _selectedDay = [calendar components:NSYearCalendarUnit|
                                           NSMonthCalendarUnit|
                                              NSDayCalendarUnit
                                   fromDate:selectedDate];
 
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
    if ([self selectedDay]) {
        return [[self calendar] dateFromComponents:[self selectedDay]];
    }
    return nil;
}

#pragma mark - Accessing day cells

- (NSArray *)visibleCells {
    return _visibleCells;
}

- (RDVCalendarDayCell *)dayCellForIndex:(NSInteger)index {
    static NSString *DayIdentifier = @"DayCell";
    
    RDVCalendarDayCell *dayCell = nil;
    
    if ([[self visibleCells] count] == [self numberOfDays]) {
        dayCell = [self visibleCells][index];
    } else {
        dayCell = [self dequeueReusableCellWithIdentifier:DayIdentifier];
        if (!dayCell) {
            dayCell = [[_dayCellClass alloc] initWithReuseIdentifier:DayIdentifier];
        }
    }
    
    if (![[self visibleCells] containsObject:dayCell]) {
        [dayCell prepareForReuse];
        [dayCell.textLabel setText:[NSString stringWithFormat:@"%d", index + 1]];
        
        if (index + 1 == [self currentDay].day &&
            [self month].month == [self currentDay].month &&
            [self month].year == [self currentDay].year) {
            [[dayCell backgroundView] setBackgroundColor:[self currentDayColor]];
        } else {
            [[dayCell backgroundView] setBackgroundColor:[self normalDayColor]];
        }
        
        [[dayCell selectedBackgroundView] setBackgroundColor:[self selectedDayColor]];
        
        [dayCell setNeedsLayout];
    }
    
    return dayCell;
}

- (NSInteger)indexForDayCell:(RDVCalendarDayCell *)cell {
    return [[self visibleCells] indexOfObject:cell];
}

- (NSInteger)indexForDayCellAtPoint:(CGPoint)point {
    RDVCalendarDayCell *cell = [self viewAtLocation:point];
    
    if (cell) {
        return [self indexForDayCell:cell];
    }
    
    return 0;
}

- (NSDate *)dateForIndex:(NSInteger)index {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:[[self month] year]];
    [dateComponents setMonth:[[self month] month]];
    [dateComponents setDay:(index + 1)];
    
    NSDate *date = [[self calendar] dateFromComponents:dateComponents];
    
    return date;
}

#pragma mark - Managing selections

- (NSInteger)indexForSelectedDayCell {
    if (_selectedDayCell) {
        return [_visibleCells indexOfObject:_selectedDayCell];
    }
    return 0;
}

- (void)selectDayCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([[self visibleCells] count] > index) {
        if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
            [[self delegate] calendarView:self willSelectDate:[self dateForIndex:index]];
        }
        
        if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectCellAtIndex:)]) {
            [[self delegate] calendarView:self willSelectCellAtIndex:index];
        }
        
        _selectedDayCell = [self dayCellForIndex:index];
        [_selectedDayCell setSelected:YES animated:animated];
        
        if (![self selectedDay]) {
            [self setSelectedDay:[[NSDateComponents alloc] init]];
        }
        
        [self.selectedDay setMonth:[[self month] month]];
        [self.selectedDay setYear:[[self month] year]];
        [self.selectedDay setDay:index + 1];
        
        if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [[self delegate] calendarView:self didSelectDate:[self dateForIndex:index]];
        }
        
        if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectCellAtIndex:)]) {
            [[self delegate] calendarView:self didSelectCellAtIndex:index];
        }
    }
}

- (void)deselectDayCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([[self visibleCells] count] > index) {
        RDVCalendarDayCell *dayCell = [self visibleCells][index];
        
        if ([dayCell isSelected]) {
            [dayCell setSelected:NO animated:animated];
        } else if ([dayCell isHighlighted]) {
            [dayCell setHighlighted:NO animated:animated];
        }
        
        if (_selectedDayCell == dayCell) {
            _selectedDayCell = nil;
        }
        
        [self setSelectedDay:nil];
    }
}

#pragma mark - Helper methods

- (NSInteger)numberOfWeeks {
    return [[self calendar] rangeOfUnit:NSDayCalendarUnit
                                 inUnit:NSWeekCalendarUnit
                                forDate:[self firstDay]].length;
}

- (NSInteger)numberOfDays {
    return [[self calendar] rangeOfUnit:NSDayCalendarUnit
                                 inUnit:NSMonthCalendarUnit
                                forDate:[self firstDay]].length;
}

- (NSInteger)numberOfDaysInFirstWeek {
    return [[self calendar] rangeOfUnit:NSDayCalendarUnit
                                 inUnit:NSWeekCalendarUnit
                                forDate:[self firstDay]].length;
}

- (RDVCalendarDayCell *)viewAtLocation:(CGPoint)location {
    RDVCalendarDayCell *view = nil;
    
    for (RDVCalendarDayCell *dayView in [self visibleCells]) {
        if (CGRectContainsPoint(dayView.frame, location)) {
            view = dayView;
        }
    }
    
    return view;
}

#pragma mark - Navigation

- (void)setDisplayedMonth:(NSDateComponents *)month {
    [self updateMonthLabelMonth:[self month]];
    [self updateMonthViewMonth:[self month]];
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didChangeMonth:)]) {
        [[self delegate] calendarView:self didChangeMonth:self.month];
    }
}

- (void)showCurrentMonth {
    [[self month] setMonth:[[self currentDay] month]];
    [[self month] setYear:[[self currentDay] year]];
 
    [self setDisplayedMonth:[self month]];
}

- (void)showPreviousMonth {
    NSCalendar *calendar = [self calendar];
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = -1;
    
    NSDate *date = [calendar dateFromComponents:self.month];
    NSDate *newDate = [calendar dateByAddingComponents:inc toDate:date options:0];
    
    self.month = [calendar components:NSYearCalendarUnit|
                  NSMonthCalendarUnit|
                  NSDayCalendarUnit|
                  NSWeekdayCalendarUnit|
                  NSCalendarCalendarUnit fromDate:newDate];   
 
    [self setDisplayedMonth:[self month]];
}

- (void)showNextMonth {

    NSCalendar *calendar = [self calendar];
    NSDateComponents *inc = [[NSDateComponents alloc] init];
    inc.month = 1;
    
    NSDate *date = [calendar dateFromComponents:self.month];
    NSDate *newDate = [calendar dateByAddingComponents:inc toDate:date options:0];
    
    self.month = [calendar components:NSYearCalendarUnit|
                  NSMonthCalendarUnit|
                  NSDayCalendarUnit|
                  NSWeekdayCalendarUnit|
                  NSCalendarCalendarUnit fromDate:newDate];
    
    [self setDisplayedMonth:[self month]];
}

#pragma mark - Locale change handling

- (void)currentLocaleDidChange:(NSNotification *)notification {
    [self setupWeekDays];
    [self updateMonthLabelMonth:[self month]];
    [self setNeedsLayout];
}

#pragma mark - Orientation cnahge handling

- (void)deviceDidChangeOrientation:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // orientation has changed to a new one
    if (UIInterfaceOrientationIsLandscape(orientation) != UIInterfaceOrientationIsLandscape(_orientation)) {
        _orientation = orientation;
        [self reloadData];
    }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self];
    
    if (touchLocation.y >= CGRectGetMaxY([[self weekDayLabels][0] frame])) {
        RDVCalendarDayCell *selectedDayCell = [self viewAtLocation:touchLocation];
        
        if (selectedDayCell && selectedDayCell != _selectedDayCell) {
            NSInteger cellIndex = [self indexForDayCell:selectedDayCell];
            
            if ([[self delegate] respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
                if (![[self delegate] calendarView:self shouldSelectDate:[self dateForIndex:cellIndex]]) {
                    return;
                }
            }
            
            if ([[self delegate] respondsToSelector:@selector(calendarView:shouldSelectCellAtIndex:)]) {
                if (![[self delegate] calendarView:self shouldSelectCellAtIndex:cellIndex]) {
                    return;
                }
            }
            
            [self deselectDayCellAtIndex:[self indexForDayCell:_selectedDayCell]
                                animated:NO];
            _selectedDayCell = selectedDayCell;
            [_selectedDayCell setHighlighted:YES];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self];
    
    if (touchLocation.y >= CGRectGetMaxY([[self weekDayLabels][0] frame])) {
        RDVCalendarDayCell *selectedDayCell = [self viewAtLocation:touchLocation];
        
        if (selectedDayCell != _selectedDayCell) {
            [self deselectDayCellAtIndex:[self indexForDayCell:_selectedDayCell]
                                animated:NO];
        }
    } else if ([_selectedDayCell isHighlighted]) {
        [_selectedDayCell setHighlighted:NO];
        _selectedDayCell = nil;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_selectedDayCell isHighlighted]) {
        [_selectedDayCell setHighlighted:NO];
        _selectedDayCell = nil;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    RDVCalendarDayCell *selectedDayCell = [self viewAtLocation:[touch locationInView:self]];
    
    if (selectedDayCell) {
        if (selectedDayCell == _selectedDayCell) {
            NSInteger cellIndex = [self indexForDayCell:selectedDayCell];
            
            [self selectDayCellAtIndex:cellIndex animated:NO];
        } else {
            [self deselectDayCellAtIndex:[self indexForDayCell:_selectedDayCell]
                                animated:NO];
        }
    }
}

@end
