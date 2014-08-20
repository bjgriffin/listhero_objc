//
//  DrawerCell.m
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "DrawerCell.h"
#import "DataManager.h"

@implementation DrawerCell

- (void)setupDrawerCell {
    _deleteImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addItemGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteList)];
    addItemGesture.numberOfTapsRequired = 1;
    [_deleteImageView addGestureRecognizer:addItemGesture];
}

- (void)deleteList {
    [self.delegate deleteListFromDrawer:_list];
}

@end
