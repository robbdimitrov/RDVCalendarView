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
}

@property NSDateComponents *selectedDay;
@property NSDateComponents *month;
@property NSDateComponents *currentDay;
@property NSDate *firstDay;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)setupWeekDays;

@end

@implementation RDVCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dayCells = [[NSMutableArray alloc] initWithCapacity:31];
        _visibleCells = [[NSMutableArray alloc] initWithCapacity:31];
        
        _currentDayColor = [UIColor lightGrayColor];
        _selectedDayColor = [UIColor grayColor];
        
        _weekDayHeight = 30.0f;
        
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        
        _currentDay = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
        
        NSDate *currentDate = [NSDate date];
        
        _monthLabel = [[UILabel alloc] init];
        [_monthLabel setFont:[UIFont systemFontOfSize:22]];
        [_monthLabel setTextColor:[UIColor blackColor]];
        [_monthLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_monthLabel];
        
        _backButton = [[UIButton alloc] init];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_backButton setTitle:@"Prev" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(previousMonthButtonTapped:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        _forwardButton = [[UIButton alloc] init];
        [_forwardButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_forwardButton setTitle:@"Next" forState:UIControlStateNormal];
        [_forwardButton addTarget:self action:@selector(nextMonthButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_forwardButton];
        
        [self setupWeekDays];
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    CGSize headerSize = CGSizeMake(viewSize.width, 60.0f);
    
    CGSize previousMonthButtonSize = CGSizeMake([[self backButton] sizeThatFits:CGSizeMake(100, 50)].width, 50);
    CGSize nextMonthButtonSize = CGSizeMake([[self forwardButton] sizeThatFits:CGSizeMake(100, 50)].width, 50);
    CGSize titleSize = CGSizeMake(viewSize.width - previousMonthButtonSize.width - nextMonthButtonSize.width - 10 - 10,
                                  50);
    
    [[self backButton] setFrame:CGRectMake(10, roundf(headerSize.height / 2 - previousMonthButtonSize.height / 2),
                                         previousMonthButtonSize.width, previousMonthButtonSize.height)];
    
    [[self monthLabel] setFrame:CGRectMake(roundf(headerSize.width / 2 - titleSize.width / 2),
                                         roundf(headerSize.height / 2 - titleSize.height / 2),
                                         titleSize.width, titleSize.height)];
    
    [[self forwardButton] setFrame:CGRectMake(headerSize.width - 10 - nextMonthButtonSize.width,
                                            roundf(headerSize.height / 2 - nextMonthButtonSize.height / 2),
                                            nextMonthButtonSize.width, nextMonthButtonSize.height)];
    
    NSInteger column = 0;
    CGFloat weekDayWidth = roundf(viewSize.width / [[self weekDayLabels] count]);
    for (UILabel *weekDayLabel in [self weekDayLabels]) {
        [weekDayLabel setFrame:CGRectMake(column * weekDayWidth, CGRectGetMaxY([[self monthLabel] frame]), weekDayWidth,
                                          [self weekDayHeight])];
        column++;
    }
    
    column = 7 - [self numberOfDaysInFirstWeek];
    CGFloat dayWidth = roundf(viewSize.width / 7) - 1;
    NSInteger row = 0;
    CGFloat startigCalendarY = CGRectGetMaxY([[self weekDayLabels][0] frame]);
    
    for (NSInteger i = 0; i < [self numberOfDays]; i++) {
        RDVCalendarDayCell *dayCell = [self dayCellForIndex:i];
        if (![[self visibleCells] containsObject:dayCell]) {
            [_visibleCells addObject:dayCell];
            [self addSubview:dayCell];
        }
        
        [dayCell setFrame:CGRectMake(column * (dayWidth + 1), startigCalendarY + row * (dayWidth + 1),
                                     dayWidth, dayWidth)];
        [dayCell setNeedsLayout];
        
        if ([dayCell superview] != self) {
            [self addSubview:dayCell];
        }
        
        if (column == 6) {
            column = 0;
            row++;
        } else {
            column++;
        }
    }
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    //TODO implement method
}

- (void)selectDayCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    
}

- (void)deselectDayCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    
}

- (void)setupWeekDays {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
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
    for (RDVCalendarDayCell *visibleCell in [self visibleCells]) {
        [visibleCell removeFromSuperview];
        [visibleCell prepareForReuse];
        [_dayCells addObject:visibleCell];
    }
    
    [_visibleCells removeAllObjects];
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

- (NSInteger)indexForCell:(RDVCalendarDayCell *)cell {
    return [[self visibleCells] indexOfObject:cell];
}

- (NSInteger)indexForRowAtPoint:(CGPoint)point {
    RDVCalendarDayCell *cell = [self viewAtLocation:point];
    
    if (cell) {
        return [self indexForCell:cell];
    }
    
    return 0;
}

- (RDVCalendarDayCell *)dayCellForRowAtIndex:(NSInteger)index {
    return [[self visibleCells] objectAtIndex:index];
}

- (NSInteger)indexForSelectedDayCell {
    if (_selectedDayCell) {
        return [_visibleCells indexOfObject:_selectedDayCell];
    }
    return 0;
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

- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM yyyy";
    
    NSDate *date = [month.calendar dateFromComponents:month];
    self.monthLabel.text = [formatter stringFromDate:date];
}

- (void)updateMonthViewMonth:(NSDateComponents *)month {
    [self setFirstDay:[month.calendar dateFromComponents:month]];
    [self reloadData];
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

- (NSArray *)visibleCells {
    return _visibleCells;
}

#pragma mark - RDVCalendarMonthViewDelegate

- (RDVCalendarDayCell *)dayCellForIndex:(NSInteger)index {
    static NSString *DayIdentifier = @"Day";
    
    RDVCalendarDayCell *dayCell = [self dequeueReusableCellWithIdentifier:DayIdentifier];
    if (!dayCell) {
        dayCell = [[RDVCalendarDayCell alloc] initWithReuseIdentifier:DayIdentifier];
    }
    
    [dayCell.textLabel setText:[NSString stringWithFormat:@"%d", index + 1]];
    
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
        _selectedDayCell = dayCell;
    }
    
    return dayCell;
}

- (NSInteger)numberOfWeeks {
    return [[[self month] calendar] rangeOfUnit:NSDayCalendarUnit
                                         inUnit:NSWeekCalendarUnit
                                        forDate:[self firstDay]].length;
}

- (NSInteger)numberOfDays {
    return [[[self month] calendar] rangeOfUnit:NSDayCalendarUnit
                                         inUnit:NSMonthCalendarUnit
                                        forDate:[self firstDay]].length;
}

- (NSInteger)numberOfDaysInFirstWeek {
    return [[[self month] calendar] rangeOfUnit:NSDayCalendarUnit
                                         inUnit:NSWeekCalendarUnit
                                        forDate:[self firstDay]].length;
}

- (void)currentLocaleDidChange:(NSNotification *)notification {
    [self setupWeekDays];
    [self updateMonthLabelMonth:[self month]];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    [self reloadData];
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:self];
    
    if (touchLocation.y >= CGRectGetMaxY([[self weekDayLabels][0] frame])) {
        RDVCalendarDayCell *selectedDayCell = [self viewAtLocation:touchLocation];
        
        if (selectedDayCell && selectedDayCell != _selectedDayCell) {
            NSInteger cellIndex = [self indexForCell:selectedDayCell];
            
            if ([[self delegate] respondsToSelector:@selector(calendarView:shouldSelectCellAtIndex:)]) {
                if (![[self delegate] calendarView:self shouldSelectCellAtIndex:cellIndex]) {
                    return;
                }
            }
            
            [_selectedDayCell setSelected:NO];
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
            if ([_selectedDayCell isSelected]) {
                [_selectedDayCell setSelected:NO];
            } else {
                [_selectedDayCell setHighlighted:NO];
            }
            
            _selectedDayCell = nil;
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
    
    if (selectedDayCell == _selectedDayCell) {
        NSInteger cellIndex = [self indexForCell:selectedDayCell];
        
        if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectCellAtIndex:)]) {
            [[self delegate] calendarView:self willSelectCellAtIndex:cellIndex];
        }
        
        [_selectedDayCell setSelected:YES];
        
        if (![self selectedDay]) {
            [self setSelectedDay:[[NSDateComponents alloc] init]];
        }
        
        [[self selectedDay] setMonth:[[self month] month]];
        [[self selectedDay] setYear:[[self month] year]];
        [[self selectedDay] setDay:cellIndex + 1];
        
        if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectCellAtIndex:)]) {
            [[self delegate] calendarView:self didSelectCellAtIndex:cellIndex];
        }
    } else {
        [_selectedDayCell setSelected:NO];
        _selectedDayCell = nil;
    }
}

@end
