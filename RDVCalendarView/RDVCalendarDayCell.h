//
//  RDVCalendarDayCell.h
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RDVCalendarDayCellSelectionStyle) {
    RDVCalendarDayCellSelectionStyleNone,
    RDVCalendarDayCellSelectionStyleNormal,
};

@interface RDVCalendarDayCell : UIView

@property(nonatomic, readonly, copy) NSString *reuseIdentifier;

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *selectedBackgroundView;


@property(nonatomic, getter = isSelected) BOOL selected;

- (id)initWithStyle:(RDVCalendarDayCellSelectionStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setSelected:(BOOL)selected;

- (void)prepareForReuse;

@end
