//
//  DrawerViewController.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DrawerCell.h"
#import "ContainerViewController.h"

@class ContainerViewController;

@interface DrawerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DrawerCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ContainerViewController *containerViewController;
@property (strong, nonatomic) NSMutableArray *lists;

@end
