//
//  RDVCalendarView.h
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDVCalendarView : UIView

@property (nonatomic) UILabel *titleView;
@property (nonatomic) UIButton *previousMonthButton;
@property (nonatomic) UIButton *nextMonthButton;

- (void)reloadData;

@end
