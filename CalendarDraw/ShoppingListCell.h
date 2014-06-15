//
//  ShoppingListCell.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"

@interface ShoppingListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoritedImageView;
@property (strong, nonatomic) ListItem *listItem;

- (void)setupItemCell:(ListItem*)listItem;
@end
