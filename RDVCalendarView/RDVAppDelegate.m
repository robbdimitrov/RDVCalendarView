//
//  RDVAppDelegate.m
//  RDVCalendarView
//
//  Created by Robert Dimitrov on 8/16/13.
//  Copyright (c) 2013 Robert Dimitrov. All rights reserved.
//

#import "RDVAppDelegate.h"
#import "RDVCalendarViewController.h"

@implementation RDVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *calendarViewController = [[RDVCalendarViewController alloc] init];
    [self.window setRootViewController:calendarViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
