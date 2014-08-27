//
//  DataManager.h
//  CalendarDraw
//
//  Created by BJ Griffin on 6/5/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListItem.h"

@interface DataManager : NSObject
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedInstance;
- (void)createList:(NSString*)title category:(NSString*)category;
- (void)addNewItemToNewList:(NSString*)name isFavorited:(BOOL)favorited details:(NSString*)details;
- (void)addNewItemToCurrentList:(List*)list name:(NSString*)name isFavorited:(BOOL)favorited details:(NSString*)details;
- (void)addItemToCurrentList:(List*)list item:(ListItem*)item;
- (void)addItemToNewList:(ListItem*)item;
- (void)updateItemFavorite:(ListItem*)item;
- (void)updateFavoriteItemsWithIdenticalNames:(NSString*)itemName;
- (void)updateItemComplete:(ListItem*)item;
- (void)deleteItem:(ListItem*)item;
- (void)deleteList:(List*)list;
- (void)deleteItemFromCurrentList:(List*)list item:(ListItem*)item;
- (NSArray*)fetchLists;
- (NSArray*)fetchItems;
@end
