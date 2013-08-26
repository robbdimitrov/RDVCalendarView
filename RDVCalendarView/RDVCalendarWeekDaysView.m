//
//  RDVCalendarWeekDaysView.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/26/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarWeekDaysView.h"

@implementation RDVCalendarWeekDaysView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _weekDays = @[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
        
        _weekDayAttributes = @{UITextAttributeFont: [UIFont systemFontOfSize:18],
                               UITextAttributeTextColor: [UIColor grayColor],
                               UITextAttributeTextShadowColor: [UIColor clearColor],
                               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                               };
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGSize viewSize = self.frame.size;
    
    NSInteger column = 0;
    CGFloat elementWidth = roundf(viewSize.width / [[self weekDays] count]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIOffset titleShadowOffset = [self.weekDayAttributes[UITextAttributeTextShadowOffset] UIOffsetValue];
    
    CGContextSetFillColorWithColor(context, [self.weekDayAttributes[UITextAttributeTextColor] CGColor]);
    CGContextSetShadowWithColor(context, CGSizeMake(titleShadowOffset.horizontal, titleShadowOffset.vertical),
                                1.0, [self.weekDayAttributes[UITextAttributeTextShadowColor] CGColor]);
    
    for (NSString *weekDayString in [self weekDays]) {
        CGSize titleSize = [weekDayString sizeWithFont:self.weekDayAttributes[UITextAttributeFont]
                                     constrainedToSize:CGSizeMake(elementWidth, viewSize.height)];
        
        [weekDayString drawInRect:CGRectMake(roundf(elementWidth / 2 - titleSize.width / 2) + column * elementWidth,
                                             roundf(viewSize.height / 2 - titleSize.height / 2),
                                             titleSize.width, titleSize.height)
                         withFont:self.weekDayAttributes[UITextAttributeFont]
                    lineBreakMode:NSLineBreakByTruncatingTail];
        
        column++;
    }
    
    CGContextRestoreGState(context);
}

@end
