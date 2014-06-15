//
//  FavoritesViewController.h
//  CalendarDraw
//
//  Created by BJ Griffin on 4/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesCell.h"
#import "ContainerViewController.h"

@class ContainerViewController;

@interface FavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) ContainerViewController *containerViewController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
