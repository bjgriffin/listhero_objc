//
//  ContainerViewController.m
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "ContainerViewController.h"
#import "ShoppingListViewController.h"
#import "DrawerViewController.h"
#import "FavoritesViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _shoppingListViewController = [[ShoppingListViewController alloc] initWithNibName:@"ShoppingListViewController" bundle:nil];
        [self.view addSubview:_shoppingListViewController.view];
        [self addChildViewController:_shoppingListViewController];
        [_shoppingListViewController didMoveToParentViewController:self];
        _shoppingListViewController.containerViewController = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setValue:@0 /*UIExtendedEdgeNone = 0*/ forKey:@"edgesForExtendedLayout"];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)getFavoritesDrawer {
    if (_favoritesViewController == nil)
    {
        self.favoritesViewController = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
        self.favoritesViewController.containerViewController = self;
        [self.view addSubview:self.favoritesViewController.view];
        
        [self addChildViewController:_favoritesViewController];
        [_favoritesViewController didMoveToParentViewController:self];
        
        _favoritesViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [self showCenterViewWithShadow:YES withOffset:2];
    
    UIView *view = self.favoritesViewController.view;
    return view;
}

- (void)showFavoritesDrawer {
    [self dismissShoppingListTextField];
    UIView *childView = [self getFavoritesDrawer];
    [self.view sendSubviewToBack:childView];
    
    
    [UIView animateWithDuration:.25 animations:^{
        _shoppingListViewController.view.frame = CGRectMake(60 - self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _favoritesDrawerOpen = YES;
                         }
                     }];
    for (UIView *view in _shoppingListViewController.view.subviews) {
        if (![view isKindOfClass:[UINavigationBar class]]) {
            view.userInteractionEnabled = NO;
        }
    }
}

- (UIView*)getDrawer {
    if (_drawerViewController == nil)
    {
        self.drawerViewController = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
        
        _drawerViewController.containerViewController = self;
        
        [self.view addSubview:self.drawerViewController.view];
        
        [self addChildViewController:_drawerViewController];
        [_drawerViewController didMoveToParentViewController:self];
        
        _drawerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }

    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.drawerViewController.view;
    return view;
}

- (void)dismissShoppingListTextField {
    [_shoppingListViewController.itemTextField resignFirstResponder];
}

- (void)showDrawer {
    [self dismissShoppingListTextField];
    UIView *childView = [self getDrawer];
    [self.view sendSubviewToBack:childView];
    
    
    [UIView animateWithDuration:.25 animations:^{
        _shoppingListViewController.view.frame = CGRectMake(self.view.frame.size.width - 60, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _drawerOpen = YES;
                         }
                     }];
    
    for (UIView *view in _shoppingListViewController.view.subviews) {
        if (![view isKindOfClass:[UINavigationBar class]]) {
            view.userInteractionEnabled = NO;
        }
    }
}

- (void)moveToOriginalPosition {
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _shoppingListViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _drawerOpen = NO;
                             _favoritesDrawerOpen = NO;
                             
                             if (_drawerViewController != nil)
                             {
                                 [self.drawerViewController.view removeFromSuperview];
                                 [self.drawerViewController removeFromParentViewController];
                                 self.drawerViewController = nil;
                             }
                             
                             if (_favoritesViewController != nil)
                             {
                                [self.favoritesViewController.view removeFromSuperview];
                                 [self.favoritesViewController removeFromParentViewController];
                                 self.favoritesViewController = nil;
                             }
                             
                             [self showCenterViewWithShadow:NO withOffset:0];
                         }
                     }];
    for (UIView *view in _shoppingListViewController.view.subviews) {
            view.userInteractionEnabled = YES;
    }
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(int)offset {
    if (value)
    {
        [_shoppingListViewController.view.layer setCornerRadius:4];
        [_shoppingListViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_shoppingListViewController.view.layer setShadowOpacity:0.8];
        [_shoppingListViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
    else
    {
        [_shoppingListViewController.view.layer setCornerRadius:0.0f];
        [_shoppingListViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
