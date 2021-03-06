//
//  BaseViewController.m
//  CalendarDraw
//
//  Created by BJ Griffin on 3/5/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
