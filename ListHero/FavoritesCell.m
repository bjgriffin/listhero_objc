//
//  FavoritesCell.m
//  CalendarDraw
//
//  Created by BJ Griffin on 4/6/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "FavoritesCell.h"
#import "DataManager.h"

@implementation FavoritesCell

- (IBAction)addItemAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(addItemFromFavoritesList:)]) {
        [self.delegate addItemFromFavoritesList:_listItem];
    }
}

- (void)setupFavoritesCell:(ListItem*)item {
    _listItem = item;
    
    _favoritedImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFavorite)];
    tapped.numberOfTapsRequired = 1;
    [_favoritedImageView addGestureRecognizer:tapped];
    
    [self updateFavorited];
}

- (void)updateFavorited {
    if (_listItem.isFavorited.boolValue) {
        [_favoritedImageView setImage:[UIImage imageNamed: @"star-icon-favorited.png"]];
    } else {
        [_favoritedImageView setImage:[UIImage imageNamed: @"star-icon-unfavorited.png"]];
    }
}

- (void)removeFavorite {
    if([self.delegate respondsToSelector:@selector(removeItemFromFavoritesList:)]) {
        [self.delegate removeItemFromFavoritesList:_listItem];
    }
}

@end
