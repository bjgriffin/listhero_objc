//
//  FavoritesCell.m
//  CalendarDraw
//
//  Created by BJ Griffin on 4/6/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "FavoritesCell.h"
#import "DataManager.h"

#define kImageViewSizeIpad 48

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
    [self iPadResizeFrames];
    [self updateFavorited];
}

- (void)iPadResizeFrames {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect plusRect = _plusButton.frame;
        CGRect titleRect = _titleLabel.frame;
        CGRect favoriteRect = _favoritedImageView.frame;
        
        plusRect.origin.x = 20;
        titleRect.size.width = 180;
        titleRect.origin.x = 70;
        favoriteRect.origin.x = 250;
        
        _plusButton.frame = plusRect;
        _titleLabel.frame = titleRect;
        _favoritedImageView.frame = favoriteRect;
    }
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
