//
//  RDVCalendarViewController.h
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVCalendarView.h"

@interface RDVCalendarViewController : UIViewController <RDVCalendarViewDelegate>

@property (nonatomic) RDVCalendarView *calendarView;

@end
