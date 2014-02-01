// RDVCalendarViewController.m
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

#import "RDVCalendarViewController.h"

@implementation RDVCalendarViewController

#pragma mark - View lifecycle

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    _calendarView = [[RDVCalendarView alloc] initWithFrame:applicationFrame];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_calendarView setSeparatorStyle:RDVCalendarViewDayCellSeparatorTypeHorizontal];
    [_calendarView setBackgroundColor:[UIColor whiteColor]];
    [_calendarView setDelegate:self];
    self.view = _calendarView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self clearsSelectionOnViewWillAppear]) {
        [[self calendarView] deselectDayCellAtIndex:[[self calendarView] indexForSelectedDayCell] animated:YES];
    }
}

@end
