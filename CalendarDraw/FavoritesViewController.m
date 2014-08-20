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
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"FavoritesCell" bundle:nil];
    
    [self.tableView registerNib:nib
           forCellReuseIdentifier:@"FavoritesCell"];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.0];
    [self.view setBackgroundColor:[UIColor colorWithRed:(0.0/255.0) green:(130.0/255.0) blue:(250.0/255.0) alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)setupFavorites {
    NSArray *items = [[DataManager sharedInstance] fetchItems];
    _favoritedItems = [[NSMutableArray alloc] init];
    for(ListItem *item in items) {
        if (item.isFavorited.boolValue) {
            [_favoritedItems addObject:item];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [headerView setBackgroundColor:[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.5]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, -10, 150, 44)];
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
    cell.delegate = _containerViewController.shoppingListViewController;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.containerViewController moveToOriginalPosition];
}

@end
