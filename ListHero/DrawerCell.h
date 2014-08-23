//
//  DrawerCell.h
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

@protocol DrawerCellDelegate <NSObject>

- (void)deleteListFromDrawer:(List*)list;

@end

@interface DrawerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *drawerOptionTitle;
@property (weak, nonatomic) List *list;
@property (weak, nonatomic) id<DrawerCellDelegate> delegate;

- (IBAction)deleteAction:(id)sender;
@end
