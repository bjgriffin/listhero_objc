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

#define kListsTitle @"Lists"
#define kSettingsTitle @"Settings"

@interface DrawerViewController () {
    NSArray *lists;
}

@end

@implementation DrawerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lists = [[DataManager sharedInstance] fetchLists];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"DrawerCell" bundle:nil];
    
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"DrawerCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrawerCell"];
    
    List *list = [lists objectAtIndex:indexPath.row];
    [cell.drawerOptionTitle setText:list.title];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.containerViewController.currentViewController isKindOfClass:[ShoppingListViewController class]]) {
        NSLog(@"list -- %@", [lists objectAtIndex:indexPath.row]);
        ShoppingListViewController *slvc = (ShoppingListViewController*)self.containerViewController.currentViewController;
        
        slvc.currentList = [lists objectAtIndex:indexPath.row];
        slvc.navItem.title = ((List*)[lists objectAtIndex:indexPath.row]).title;
        [slvc.tableView reloadData];
    }
    
    [self.containerViewController moveToOriginalPosition];
}

@end
