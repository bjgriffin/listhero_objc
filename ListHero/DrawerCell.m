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

- (IBAction)deleteAction:(id)sender {
    [self.delegate deleteListFromDrawer:_list];
}

- (void)iPadResizeFrames {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect titleRect = _drawerOptionTitle.frame;
        CGRect deleteRect = _deleteButton.frame;
        
        titleRect.size.width = 230;
        deleteRect.origin.x = 250;
        
        _drawerOptionTitle.frame = titleRect;
        _deleteButton.frame = deleteRect;
    }
}

@end
