//
//  RDVCalendarWeekDaysHeader.h
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/26/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDVCalendarWeekDaysHeader : UIView

@property (nonatomic) NSArray *weekDays;
@property (nonatomic) NSDictionary *weekDayAttributes;

- (void)setupWeekDays;

@end
