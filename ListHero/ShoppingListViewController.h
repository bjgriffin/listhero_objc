//
//  ShoppingListViewController.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "FavoritesCell.h"
#import "ShoppingListCell.h"
#import "List.h"
#import "ListItem.h"

@class ContainerViewController;

@interface ShoppingListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate, UIAlertViewDelegate, UITextFieldDelegate, FavoritesCellDelegate, ShoppingListCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoritesBarButtonItem;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (strong, nonatomic) List *currentList;
@property (weak, nonatomic) ContainerViewController *containerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (IBAction)addItemAction:(id)sender;
- (void)adjustTableView;
@end
