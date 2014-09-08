//
//  ShoppingListViewController.m
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "DataManager.h"

#define NAVIGATION_BAR_HEIGHT 44
#define ADD_UNIT_ID_BOTTOM_BANNER @"ca-app-pub-4183203351642526/8413792290"

@interface ShoppingListViewController () {
    UIButton *addListButton;
    UIAlertView *createListAlertView;
    NSArray *sortedListItems;
    GADBannerView *bannerView;
}

@end

@implementation ShoppingListViewController

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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [_iPadNewListButton addTarget:self action:@selector(createList) forControlEvents:UIControlEventTouchUpInside];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    } else {
        addListButton = [self addNewListButton:@"New List"];
        [addListButton addTarget:self action:@selector(createList) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addListButton];
        [self adjustTableView];
    }
    
    [_itemTextField setDelegate:self];
    [_backBarButtonItem setAction:@selector(drawerAction)];
    [_favoritesBarButtonItem setAction:@selector(favoritesDrawerAction)];
    [self setupGADBannerView];
}

- (void)adjustTableView {
    CGRect rect = self.tableView.frame;

    if (!self.navItem.title) {
        _itemTextField.hidden = YES;
        _plusButton.hidden = YES;
        rect.origin.y -= _itemTextField.frame.size.height;
    } else {
        if (_itemTextField.hidden) {
            _itemTextField.hidden = NO;
            _plusButton.hidden = NO;
            rect.origin.y += _itemTextField.frame.size.height;
        }
    }
    
    rect.size.height = addListButton.frame.origin.y - (_itemTextField.frame.size.height + NAVIGATION_BAR_HEIGHT + [UIApplication sharedApplication].statusBarFrame.size.height + bannerView.frame.size.height);

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
    createListAlertView = [[UIAlertView alloc] initWithTitle:@"Create New List" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    createListAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [createListAlertView textFieldAtIndex:0];
    textField.placeholder = @"List title";
    [createListAlertView show];
}

- (IBAction)addItemAction:(id)sender {
    if (![_itemTextField.text isEqual:@""]) {
        if (!_currentList) {
            [[DataManager sharedInstance] addNewItemToNewList:_itemTextField.text isFavorited:NO details:nil];
            _currentList = (List*)[[[DataManager sharedInstance] fetchLists] lastObject];
            _navItem.title = _currentList.title;
            [self.tableView reloadData];
        } else {
            if ([self currentListContainsListItem:_itemTextField.text]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Done!" message:@"Favorite already exist in list" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
            } else {
                [[DataManager sharedInstance] addNewItemToCurrentList:_currentList name:_itemTextField.text  isFavorited:NO details:nil];
                [self.tableView reloadData];
                _itemTextField.text = @"";
                [_itemTextField resignFirstResponder];
            }
        }
    } else {
        [_itemTextField becomeFirstResponder];
    }
}

#pragma mark - Drawer Actions

- (void)drawerAction {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        if (self.containerViewController.drawerOpen) {
            [self.containerViewController moveToOriginalPosition];
        } else {
            [self.containerViewController showDrawer];
        }
    }
}

- (void)favoritesDrawerAction {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        if (self.containerViewController.favoritesDrawerOpen) {
            [self.containerViewController moveToOriginalPosition];
        } else {
            [self.containerViewController showFavoritesDrawer];
        }
    }
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [[DataManager sharedInstance] createList:[alertView textFieldAtIndex:0].text category:nil];
            _currentList = (List*)[[[DataManager sharedInstance] fetchLists] lastObject];
            _navItem.title = _currentList.title;
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                [self adjustTableView];
            } else {
                AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                delegate.drawerViewController.lists = [[NSMutableArray alloc] initWithArray:[[DataManager sharedInstance] fetchLists]];
                [delegate.drawerViewController.tableView reloadData];
            }
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
    cell.delegate = self;
    cell.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:0.8];
    
    sortedListItems = [[_currentList.items allObjects] sortedArrayUsingComparator:^NSComparisonResult(ListItem *item1, ListItem *item2){
        
        return [item1.date compare:item2.date];
        
    }];
    ListItem *item = [sortedListItems objectAtIndex:indexPath.row];
    cell.title.text = item.name;
    [cell setupItemCell:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float cellHeight = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 88 : 44;
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ListItem *item = [sortedListItems objectAtIndex:indexPath.row];
        [[DataManager sharedInstance] deleteItemFromCurrentList:_currentList item:item];
        [self.tableView reloadData];
    }
}

#pragma mark -- ShoppingListCell delegate methods
- (void)deleteItemFromShoppingList:(ListItem *)item {
    [[DataManager sharedInstance] deleteItemFromCurrentList:_currentList item:item];
    [self.tableView reloadData];
}

- (BOOL)currentListContainsListItem:(NSString*)itemName {
    BOOL hasItem = NO;
    for (ListItem *currentListItem in _currentList.items) {
        if ([currentListItem.name isEqual:itemName]) {
            hasItem = YES;
            break;
        }
    }
    return hasItem;
}

#pragma mark -- FavoritesCell delegate methods
- (void)addItemFromFavoritesList:(ListItem*)item {
    if (!_currentList) {
        [[DataManager sharedInstance] addNewItemToNewList:item.name isFavorited:[item.isFavorited boolValue] details:nil];
        _currentList = (List*)[[[DataManager sharedInstance] fetchLists] lastObject];
        _navItem.title = _currentList.title;
        [self.tableView reloadData];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [self adjustTableView];
        }
    } else {
        if ([self currentListContainsListItem:item.name]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Done!" message:@"Favorite already exist in list" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        } else {
            [[DataManager sharedInstance] addNewItemToCurrentList:_currentList name:item.name isFavorited:[item.isFavorited boolValue] details:nil];
            [self.tableView reloadData];
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                [self adjustTableView];
            }
        }
    }
}

- (void)removeItemFromFavoritesList:(ListItem *)item {
    [[DataManager sharedInstance] updateFavoriteItemsWithIdenticalNames:item.name];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        for (ListItem *itm in delegate.favoritesViewController.favoritedItems) {
            if ([itm.name isEqualToString:item.name]) {
                [delegate.favoritesViewController.favoritedItems removeObject:itm];
                break;
            }
        }
        [delegate.favoritesViewController setupFavorites];
        [delegate.favoritesViewController.tableView reloadData];
    } else {
        [_containerViewController.favoritesViewController.favoritedItems removeObject:item];
        for (ListItem *itm in _containerViewController.favoritesViewController.favoritedItems) {
            if ([itm.name isEqualToString:item.name]) {
                [_containerViewController.favoritesViewController.favoritedItems removeObject:itm];
                break;
            }
        }
        [_containerViewController.favoritesViewController.tableView reloadData];
    }
    [self.tableView reloadData];
}

#pragma mark -- SplitViewController delegate methods

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}

#pragma mark -- Google AdMob methods

- (void)setupGADBannerView {
    CGPoint origin = CGPointMake(0.0, self.view.frame.size.height - (kGADAdSizeBanner.size.height + addListButton.frame.size.height));

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bannerView = [[GADBannerView alloc] init];
        bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.iPadBannerContainer addSubview:bannerView];
        [self.iPadBannerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bannerView]|" options:NSLayoutFormatDirectionMask metrics:nil views:NSDictionaryOfVariableBindings(bannerView)]];
        [self.iPadBannerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bannerView]|" options:NSLayoutFormatDirectionMask metrics:nil views:NSDictionaryOfVariableBindings(bannerView)]];
    } else {
        bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
        [self.view addSubview:bannerView];
    }
    
    bannerView.adUnitID = ADD_UNIT_ID_BOTTOM_BANNER;
    bannerView.rootViewController = self;
    [bannerView loadRequest:[self createGADRequest]];
    
    //Adjust TableView Height iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect rect = self.tableView.frame;
        rect.size.height -= bannerView.frame.size.height;
        self.tableView.frame = rect;
        if ([[UIScreen mainScreen] bounds].size.height < 568) {
            CGRect rect1 = bannerView.frame;
            rect1.origin.y = self.tableView.frame.origin.y + (self.tableView.frame.size.height+self.itemTextField.frame.size.height);
            bannerView.frame = rect1;
        }
    }
}

- (GADRequest*)createGADRequest {
    GADRequest *request = [GADRequest request];
//    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    return request;
}

@end
