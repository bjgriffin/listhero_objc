//
//  ShoppingListCell.m
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "ShoppingListCell.h"
#import "DataManager.h"
#import "AppDelegate.h"

@implementation ShoppingListCell

- (IBAction)deleteAction:(id)sender {
    [self.delegate deleteItemFromShoppingList:_listItem];
}

- (void)setupItemCell:(ListItem*)item {
    _listItem = item;
    _favoritedImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateFavoritedData)];
    tapped.numberOfTapsRequired = 1;
    [_favoritedImageView addGestureRecognizer:tapped];
    
    _checkboxImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateCompletedData)];
    tapped2.numberOfTapsRequired = 1;
    [_checkboxImageView addGestureRecognizer:tapped2];
    
    [self updateFavorited];
    [self updateCompleted];
}



- (void)updateFavorited {
    if (_listItem.isFavorited.boolValue) {
        [_favoritedImageView setImage:[UIImage imageNamed: @"star-icon-favorited.png"]];
    } else {
        [_favoritedImageView setImage:[UIImage imageNamed: @"star-icon-unfavorited.png"]];
    }
}

- (void)updateCompleted {
    if ((BOOL)_listItem.isComplete.boolValue) {
        [_checkboxImageView setImage:[UIImage imageNamed: @"complete.png"]];
    } else {
        [_checkboxImageView setImage:[UIImage imageNamed: @"incomplete.png"]];
    }
}

- (void)updateFavoritedData {
    [[DataManager sharedInstance] updateFavoriteItemsWithIdenticalNames:_listItem.name];
    
    [self updateFavorited];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.favoritesViewController setupFavorites];
        [delegate.favoritesViewController.tableView reloadData];
    }
}

- (void)updateCompletedData {
    [[DataManager sharedInstance] updateItemComplete:_listItem];
    
    [self updateCompleted];
}

@end
