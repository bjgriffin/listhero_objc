//
//  BaseViewController.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/5/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"

@class ContainerViewController;

@interface BaseViewController : UIViewController
@property (strong, nonatomic) ContainerViewController *containerViewController;

- (void)drawerAction;
- (void)favoritesDrawerAction;
@end
