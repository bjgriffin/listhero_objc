//
//  AppDelegate.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "List.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ContainerViewController *containerViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
