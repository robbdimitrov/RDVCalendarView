//
//  RDVCalendarMonthView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/26/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarMonthView.h"
#import "RDVCalendarDayCell.h"

@interface RDVCalendarMonthView () {
    
}

@property (nonatomic) NSMutableArray *visibleCells;
@property (nonatomic) NSMutableArray *dayCells;

@property (nonatomic) RDVCalendarDayCell *selectedDayCell;

@property (nonatomic) NSInteger numberOfDays;
@property (nonatomic) NSInteger numberOfWeeks;

@property (nonatomic) NSInteger firstWeekDays;

@end

@implementation RDVCalendarMonthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dayCells = [[NSMutableArray alloc] init];
        _visibleCells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    
    NSInteger column = 7 - [self firstWeekDays];
    CGFloat dayWidth = roundf(viewSize.width / 7);
    NSInteger row = 0;
    
    for (NSInteger i = 0; i < [self numberOfDays]; i++) {
        RDVCalendarDayCell *dayCell = nil;
        
        if ([[self delegate] respondsToSelector:@selector(calendarMonthView:dayCellForIndex:)]) {
            dayCell = [[self delegate] calendarMonthView:self dayCellForIndex:i];
            if (![[self visibleCells] containsObject:dayCell]) {
                [[self visibleCells] addObject:dayCell];
                [self addSubview:dayCell];
            }
        }
        
        [dayCell setFrame:CGRectMake(column * dayWidth, row * dayWidth, dayWidth, dayWidth)];
        [dayCell setBackgroundColor:[UIColor whiteColor]];
        
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

- (void)reloadData {
    if ([[self delegate] respondsToSelector:@selector(numberOfWeeksInCalendarMonthView:)]) {
        [self setNumberOfWeeks:[[self delegate] numberOfWeeksInCalendarMonthView:self]];
    }
    
    if ([[self delegate] respondsToSelector:@selector(numberOfDaysInCalendarMonthView:)]) {
        [self setNumberOfDays:[[self delegate] numberOfDaysInCalendarMonthView:self]];
    }
    
    if ([[self delegate] respondsToSelector:@selector(numberOfDaysInFirstWeek:)]) {
        [self setFirstWeekDays:[[self delegate] numberOfDaysInFirstWeek:self]];
    }
    
    for (RDVCalendarDayCell *visibleCell in [self visibleCells]) {
        [visibleCell removeFromSuperview];
        [visibleCell prepareForReuse];
        [[self dayCells] addObject:visibleCell];
    }
    
    [[self visibleCells] removeAllObjects];
    
    [self setNeedsLayout];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    UIView *dayCell = nil;
    
    if ([[self dayCells] count]) {
        dayCell = [[self dayCells] objectAtIndex:0];
        [[self dayCells] removeObjectAtIndex:0];
    }
    
    return dayCell;
}

- (NSInteger)indexForCell:(UITableViewCell *)cell {
    return 0;
}

- (NSInteger)indexForRowAtPoint:(CGPoint)point {
    return 0;
}

- (RDVCalendarDayCell *)cellForRowAtIndex:(NSInteger)index {
    return nil;
}

- (NSInteger)indexForSelectedCell {
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

#pragma mark - Touch handling

- (void)handleTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    RDVCalendarDayCell *selectedCell = [self viewAtLocation:[touch locationInView:self]];
    
    if (selectedCell && selectedCell != [self selectedDayCell]) {
        [[self selectedDayCell] setSelected:NO];
        [self setSelectedDayCell:selectedCell];
        [[self selectedDayCell] setSelected:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches withEvent:event];
}

@end
