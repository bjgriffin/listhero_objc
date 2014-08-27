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
@property (weak, nonatomic) IBOutlet UIImageView *favoritedImageView;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (nonatomic, strong) id<FavoritesCellDelegate> delegate;
@property (strong, nonatomic) ListItem *listItem;
- (IBAction)addItemAction:(id)sender;
- (void)setupFavoritesCell:(ListItem*)item;
@end
