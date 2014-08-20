//
//  ShoppingListViewController.m
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "ShoppingListCell.h"
#import "DataManager.h"
#import "ListItem.h"

#define NAVIGATION_BAR_HEIGHT 44

@interface ShoppingListViewController () {
    UIButton *addListButton;
    UIAlertView *createListAlertView;
}

@end

@implementation ShoppingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"ShoppingListCell" bundle:nil];
    
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"ShoppingListCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.0];
    self.tableView.allowsSelection = NO;
    
    if (_currentList) {
        _navItem.title = _currentList.title;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *lastListURI = [defaults objectForKey:@"lastListURI"];
        if (lastListURI != nil) {
            NSArray *lists = [[DataManager sharedInstance] fetchLists];
            
            for (List *list in lists) {
                if ([list.objectID.URIRepresentation.absoluteString isEqual:lastListURI]) {
                    _currentList = list;
                    _navItem.title = _currentList.title;
                }
            }
        }
    }
    
    addListButton = [self addNewListButton:@"New List"];
    [addListButton addTarget:self action:@selector(createList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addListButton];
    [self adjustTableView];
    
    UITapGestureRecognizer *addItemGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addItem)];
    [_addItemButtonImage addGestureRecognizer:addItemGesture];
    
    [_itemTextField setDelegate:self];
    [_backBarButtonItem setAction:@selector(drawerAction)];
    [_favoritesBarButtonItem setAction:@selector(favoritesDrawerAction)];
}

- (void)adjustTableView {
    CGRect rect = self.tableView.frame;

    if (!self.navItem.title) {
        _itemTextField.hidden = YES;
        _addItemButtonImage.hidden = YES;
        rect.origin.y -= _itemTextField.frame.size.height;
    } else {
        if (_itemTextField.hidden) {
            _itemTextField.hidden = NO;
            _addItemButtonImage.hidden = NO;
            rect.origin.y += _itemTextField.frame.size.height;
        }
    }
    self.tableView.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (UIButton*)addNewListButton:(NSString*)title {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, screenRect.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - (NAVIGATION_BAR_HEIGHT+5), screenRect.size.width, 67)];
    [button setTitleColor:[UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"list-hero-button-normal"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    return button;
}

- (void)createList {
    createListAlertView = [[UIAlertView alloc] initWithTitle:@"Create Your List" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    createListAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [createListAlertView textFieldAtIndex:0];
    textField.placeholder = @"List title";
    [createListAlertView show];
}

- (void)addItem {
    if (![_itemTextField.text isEqual:@""]) {
        if (!_currentList) {
            [[DataManager sharedInstance] addNewItemToNewList:_itemTextField.text isFavorited:NO details:nil];
            _currentList = (List*)[[[DataManager sharedInstance] fetchLists] lastObject];
            _navItem.title = _currentList.title;
            [self.tableView reloadData];
        } else {
            [[DataManager sharedInstance] addNewItemToCurrentList:_currentList name:_itemTextField.text  isFavorited:NO details:nil];
            [self.tableView reloadData];
            _itemTextField.text = @"";
            [_itemTextField resignFirstResponder];
        }
    }
}

#pragma mark - Drawer Actions

- (void)drawerAction {
    if (self.containerViewController.drawerOpen) {
        [self.containerViewController moveToOriginalPosition];
    } else {
        [self.containerViewController showDrawer];
    }
}

- (void)favoritesDrawerAction {
    if (self.containerViewController.favoritesDrawerOpen) {
        [self.containerViewController moveToOriginalPosition];
    } else {
        [self.containerViewController showFavoritesDrawer];
    }
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [[DataManager sharedInstance] createList:[alertView textFieldAtIndex:0].text category:nil];
            _currentList = (List*)[[[DataManager sharedInstance] fetchLists] lastObject];
            _navItem.title = _currentList.title;
            [self adjustTableView];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingListCell"];
    cell.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:0.8];
    
    NSArray *items = [_currentList.items allObjects];
    ListItem *item = [items objectAtIndex:indexPath.row];
    cell.title.text = item.name;
    [cell setupItemCell:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [_currentList.items allObjects];
        ListItem *item = [items objectAtIndex:indexPath.row];
        [[DataManager sharedInstance] deleteItemFromCurrentList:_currentList item:item];
        [self.tableView reloadData];
    }
}

#pragma mark -- FavoritesCell delegate methods
- (void)addItemFromFavoritesList:(ListItem*)item {
    if (!_currentList) {
        [[DataManager sharedInstance] addItemToNewList:item];
        _currentList = (List*)[[[DataManager sharedInstance] fetchLists] lastObject];
        _navItem.title = _currentList.title;
        [self.tableView reloadData];
    } else {
        if ([_currentList.items containsObject:item]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Done!" message:@"Favorite already exist in list" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        } else {
            [[DataManager sharedInstance] addItemToCurrentList:_currentList item:item];
            [self.tableView reloadData];
        }
    }
}

- (void)removeItemFromFavoritesList:(ListItem *)item {
    [[DataManager sharedInstance] updateItemFavorite:item];
    [_containerViewController.favoritesViewController.favoritedItems removeObject:item];
    [_containerViewController.favoritesViewController.tableView reloadData];
}

@end
