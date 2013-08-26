//
//  RDVCalendarView.h
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDVCalendarHeaderView;

@protocol RDVCalendarViewDelegate;

@interface RDVCalendarView : UIView

@property (weak) id <RDVCalendarViewDelegate> delegate;
@property (nonatomic) RDVCalendarHeaderView *headerView;
@property (nonatomic) UIColor *separatorColor;

@property NSDate *selectedDate;

- (void)reloadData;

@end

@protocol RDVCalendarViewDelegate <NSObject>
@optional
- (BOOL)calendarView:(RDVCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
- (void)calendarView:(RDVCalendarView *)calendarView willSelectDate:(NSDate *)date;
- (void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date;
@end
