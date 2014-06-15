//
//  ShoppingListViewController.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "List.h"

@class ContainerViewController;

@interface ShoppingListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoritesBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *addItemButtonImage;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (strong, nonatomic) List *currentList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) ContainerViewController *containerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
