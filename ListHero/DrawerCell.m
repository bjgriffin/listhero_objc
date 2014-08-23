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

@end
