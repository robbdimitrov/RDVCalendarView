//
//  RDVCalendarViewController.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVCalendarViewController.h"
#import "RDVCalendarView.h"

@interface RDVCalendarViewController ()

@end

@implementation RDVCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    _calendarView = [[RDVCalendarView alloc] initWithFrame:applicationFrame];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_calendarView setBackgroundColor:[UIColor whiteColor]];
    self.view = _calendarView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.calendarView titleView] setText:@"August"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
