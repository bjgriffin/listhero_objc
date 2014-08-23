//
//  DrawerViewController.m
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "DrawerViewController.h"
#import "ShoppingListViewController.h"
#import "DataManager.h"
#import "List.h"

#define kDrawerTitle @"Your Lists"

@interface DrawerViewController () {
    NSMutableArray *lists;
    List *listToDelete;
    UIAlertView *deleteListAlertView;
}

@end

@implementation DrawerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lists = [[NSMutableArray alloc] initWithArray:[[DataManager sharedInstance] fetchLists]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"DrawerCell" bundle:nil];
    
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"DrawerCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.0];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(0.0/255.0) green:(130.0/255.0) blue:(250.0/255.0) alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            [[DataManager sharedInstance] deleteList:listToDelete];
            [lists removeObject:listToDelete];
            if (_containerViewController.shoppingListViewController.currentList == listToDelete) {
                _containerViewController.shoppingListViewController.navItem.title = nil;
                _containerViewController.shoppingListViewController.currentList = nil;
                [_containerViewController.shoppingListViewController adjustTableView];
                [_containerViewController.shoppingListViewController.tableView reloadData];

            }
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - DrawerCellDelegate

- (void)deleteListFromDrawer:(List *)list {
    listToDelete = list;
    deleteListAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Would you like to delete %@ ?", listToDelete.title] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    deleteListAlertView.alertViewStyle = UIAlertViewStyleDefault;
    [deleteListAlertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [lists count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [headerView setBackgroundColor:[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.5]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, -10, 150, 44)];
    label.text=kDrawerTitle;
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrawerCell"];
    cell.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:0.3];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    List *list = [lists objectAtIndex:indexPath.row];
    cell.list = list;
    [cell.drawerOptionTitle setText:list.title];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.containerViewController.shoppingListViewController.currentList = [lists objectAtIndex:indexPath.row];
    self.containerViewController.shoppingListViewController.navItem.title = ((List*)[lists objectAtIndex:indexPath.row]).title;
    [self.containerViewController.shoppingListViewController adjustTableView];
    [self.containerViewController.shoppingListViewController.tableView reloadData];

    [self.containerViewController moveToOriginalPosition];
}

@end
