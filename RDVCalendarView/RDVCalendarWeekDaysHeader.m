// RDVCalendarWeekDaysHeader.m
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVCalendarWeekDaysHeader.h"

@implementation RDVCalendarWeekDaysHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self setupWeekDays];
        
        _weekDayAttributes = @{UITextAttributeFont: [UIFont systemFontOfSize:14],
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

- (void)setupWeekDays {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSInteger firstWeekDay = [calendar firstWeekday] - 1;
    
    // We need an NSDateFormatter to have access to the localized weekday strings
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSArray *weekSymbols = [formatter shortWeekdaySymbols];
    
    // weekdaySymbols returns and array of strings
    NSMutableArray *weekDays = [[NSMutableArray alloc] initWithCapacity:[weekSymbols count]];
    for (NSInteger day = firstWeekDay; day < [weekSymbols count]; day++) {
        [weekDays addObject:[weekSymbols objectAtIndex:day]];
    }
    
    if (firstWeekDay != 0) {
        for (NSInteger day = 0; day < firstWeekDay; day++) {
            [weekDays addObject:[weekSymbols objectAtIndex:day]];
        }
    }
    
    _weekDays = [NSArray arrayWithArray:weekDays];
    
    [self setNeedsDisplay];
}

@end
