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
- (void)addItemToNewList:(NSString*)name favorited:(BOOL)favorited details:(NSString*)details;
- (void)addItemToCurrentList:(List*)list name:(NSString*)name favorited:(BOOL)favorited details:(NSString*)details;
- (void)updateItemFavorite:(ListItem*)item;
- (void)updateItemComplete:(ListItem*)item;
- (NSArray*)fetchLists;
@end
