//
//  FavoritesViewController.m
//  CalendarDraw
//
//  Created by BJ Griffin on 4/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ShoppingListViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"FavoritesCell" bundle:nil];
    
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"FavoritesCell"];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritesCell"];

//    [cell.drawerOptionTitle setText:kFavoriteTitle];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *controller;
    
    switch (indexPath.row) {
        case 0:
            controller = [[ShoppingListViewController alloc] initWithNibName:@"ShoppingListViewController" bundle:nil];
            if (controller.class != self.containerViewController.currentViewController.class) {
                [self.containerViewController changeCurrentViewController:controller];
            }
            [self.containerViewController moveToOriginalPosition];
            break;
            
        default:
            break;
    }
}

@end
