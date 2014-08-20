//
//  FavoritesCell.h
//  CalendarDraw
//
//  Created by BJ Griffin on 4/6/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"

@protocol FavoritesCellDelegate <NSObject>

- (void)addItemFromFavoritesList:(ListItem*)item;
- (void)removeItemFromFavoritesList:(ListItem*)item;

@end

@interface FavoritesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoritedImageView;
@property (nonatomic, strong) id<FavoritesCellDelegate> delegate;
@property (strong, nonatomic) ListItem *listItem;
- (void)setupFavoritesCell:(ListItem*)item;
@end
