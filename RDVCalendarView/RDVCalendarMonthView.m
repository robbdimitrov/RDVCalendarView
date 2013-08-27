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

@property (nonatomic) NSArray *dayViews;
@property (nonatomic) RDVCalendarDayCell *selectedDayCell;

@end

@implementation RDVCalendarMonthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *dayViews = [[NSMutableArray alloc] initWithCapacity:30];
        
        for (NSInteger i = 0; i < 30; i++) {
            RDVCalendarDayCell *dayCell = [[RDVCalendarDayCell alloc] init];
            [dayCell.titleLabel setText:[NSString stringWithFormat:@"%d", i + 1]];
            [dayCell setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:dayCell];
            [dayViews addObject:dayCell];
        }
        
        _dayViews = [[NSArray alloc] initWithArray:dayViews];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize viewSize = self.frame.size;
    
    NSInteger column = 0;
    CGFloat dayWidth = roundf(viewSize.width / 7);
    NSInteger row = 0;
    
    for (UIView *dayView in [self dayViews]) {
        [dayView setFrame:CGRectMake(column * dayWidth, row * dayWidth, dayWidth, dayWidth)];
        
        if (column == 6) {
            column = 0;
            row++;
        } else {
            column++;
        }
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    return nil;
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    return nil;
}

- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point {
    return nil;
}

- (RDVCalendarDayCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSIndexPath *)indexPathForSelectedCell {
    return nil;
}

- (RDVCalendarDayCell *)viewAtLocation:(CGPoint)location {
    RDVCalendarDayCell *view = nil;
    
    for (RDVCalendarDayCell *dayView in [self dayViews]) {
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
