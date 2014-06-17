//
//  FavoritesCell.m
//  CalendarDraw
//
//  Created by BJ Griffin on 4/6/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "FavoritesCell.h"

@implementation FavoritesCell

- (void)setupFavoritesCell:(ListItem*)item {
    _listItem = item;
    _addImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addItemGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addItem)];
    addItemGesture.numberOfTapsRequired = 1;
    [_addImageView addGestureRecognizer:addItemGesture];
}

- (void)addItem {
    if([self.delegate respondsToSelector:@selector(addItemFromFavoritesList:)]) {
        [self.delegate addItemFromFavoritesList:_listItem];
    }
}

@end
