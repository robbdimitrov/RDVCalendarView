//
//  RDVCalendarDayView.h
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDVCalendarDayView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *selectedBackgroundView;

@end
