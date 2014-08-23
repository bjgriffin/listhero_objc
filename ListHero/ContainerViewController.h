//
//  ContainerViewController.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListViewController.h"
#import "DrawerViewController.h"
#import "FavoritesViewController.h"

@class ShoppingListViewController;
@class DrawerViewController;
@class FavoritesViewController;

@interface ContainerViewController : UIViewController
@property (strong, nonatomic) ShoppingListViewController *shoppingListViewController;
@property (strong, nonatomic) DrawerViewController *drawerViewController;
@property (strong, nonatomic) FavoritesViewController *favoritesViewController;
@property (nonatomic) BOOL drawerOpen;
@property (nonatomic) BOOL favoritesDrawerOpen;

- (void)showDrawer;
- (void)showFavoritesDrawer;
- (void)moveToOriginalPosition;
@end
