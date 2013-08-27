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
@property (nonatomic) NSIndexPath *selectedIndexPath;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;
- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point;
- (RDVCalendarDayCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForSelectedCell;

@end

@protocol RDVCalendarMonthViewDelegate <NSObject>

@optional
- (BOOL)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView shouldSelectDayCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView willSelectDayCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView didSelectDayCellAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfWeeksInCalendarMonthView:(RDVCalendarMonthView *)calendarMonthView;
- (RDVCalendarDayCell *)calendarMonthView:(RDVCalendarMonthView *)calendarMonthView dayCellForIndexPath:(NSIndexPath *)indexPath;

@end
