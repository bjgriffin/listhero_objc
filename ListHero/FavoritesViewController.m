//
//  FavoritesViewController.m
//  CalendarDraw
//
//  Created by BJ Griffin on 4/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ShoppingListViewController.h"
#import "DataManager.h"

#define kFavoritesTitle @"Your Favorites"
#define kNavigationBarPlusStatusBarHeight 64

@interface FavoritesViewController ()
{
}

@end

@implementation FavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupFavorites];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"FavoritesCell" bundle:nil];
    
    [self.tableView registerNib:nib
           forCellReuseIdentifier:@"FavoritesCell"];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.0];
    [self.view setBackgroundColor:[UIColor colorWithRed:(0.0/255.0) green:(130.0/255.0) blue:(250.0/255.0) alpha:1.0]];
    [self iPadAdjustFavoritesListHeight];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.title = @"Favorites";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupFavorites {
    _favoritedItems = [[NSMutableArray alloc] init];
    NSMutableArray *favorites = [[NSMutableArray alloc] init];
    NSArray *items = [[DataManager sharedInstance] fetchItems];
    for(ListItem *item in items) {
        if (item.isFavorited.boolValue) {
            [favorites addObject:item];
        }
    }
    
    NSMutableArray *uniqueFavorites = [[NSMutableArray alloc] init];
    uniqueFavorites = [favorites valueForKeyPath:@"@distinctUnionOfObjects.name"];
    
    int count = 0;
    for(ListItem *item in favorites) {
        if (count != uniqueFavorites.count) {
            if ([uniqueFavorites containsObject:item.name]) {
                NSMutableArray *favoriteItemsStringsDict = [_favoritedItems valueForKeyPath:@"@distinctUnionOfObjects.name"];
                if (![favoriteItemsStringsDict containsObject:item.name]) {
                    [_favoritedItems addObject:item];
                    count++;
                }
            }
        }
    }
}

- (void)iPadAdjustFavoritesListHeight {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect rect = self.tableView.frame;
        rect.origin.y += kNavigationBarPlusStatusBarHeight;
        rect.size.height -= self.tabBarController.tabBar.frame.size.height + kNavigationBarPlusStatusBarHeight;
        self.tableView.frame = rect;
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float cellHeight = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 54 : 44;
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [headerView setBackgroundColor:[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.5]];
    
    UILabel *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, -10, 150, 44)];
    } else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(75, -10, 150, 44)];
    }
    
    label.text=kFavoritesTitle;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_favoritedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritesCell"];
    cell.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:0.3];
    ListItem *item = [_favoritedItems objectAtIndex:indexPath.row];
    [cell setupFavoritesCell:item];
    [cell.titleLabel setText:item.name];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        cell.delegate = delegate.shoppingListViewController;
    } else {
        cell.delegate = _containerViewController.shoppingListViewController;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [self.containerViewController moveToOriginalPosition];
    }
}

@end
