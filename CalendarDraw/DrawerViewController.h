//
//  DrawerViewController.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerCell.h"
#import "ContainerViewController.h"

@class ContainerViewController;

@interface DrawerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ContainerViewController *containerViewController;

@end
