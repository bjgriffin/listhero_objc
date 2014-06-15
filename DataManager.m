//
//  DataManager.m
//  CalendarDraw
//
//  Created by BJ Griffin on 6/5/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "DataManager.h"
#import "List.h"
#import "ListItem.h"

@implementation DataManager

+ (instancetype)sharedInstance
{
    static DataManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setupCoreData];
    });
    return sharedInstance;
}

- (void)createList:(NSString*)title category:(NSString*)category {
    List *list = [NSEntityDescription
     insertNewObjectForEntityForName:@"List"
     inManagedObjectContext:self.managedObjectContext];
    
    list.title = title;
    list.category = category;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)addItemToNewList:(NSString*)name favorited:(BOOL)favorited details:(NSString*)details {
    List *list = [NSEntityDescription
                   insertNewObjectForEntityForName:@"List"
                   inManagedObjectContext:self.managedObjectContext];
    
    list.title = name;
    list.category = @"";
    
    ListItem *item = [NSEntityDescription
                       insertNewObjectForEntityForName:@"ListItem"
                       inManagedObjectContext:self.managedObjectContext];
    
    item.name = name;
    item.isFavorited = [NSNumber numberWithBool:favorited];
    item.details = details;
    [item addListsObject:list];
    
    [list addItemsObject:item];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)addItemToCurrentList:(List*)list name:(NSString*)name favorited:(BOOL)favorited details:(NSString*)details {
    ListItem *item = [NSEntityDescription
                       insertNewObjectForEntityForName:@"ListItem"
                       inManagedObjectContext:self.managedObjectContext];
    
    item.name = name;
    item.isFavorited = [NSNumber numberWithBool:favorited];
    item.details = details;
    [item addListsObject:list];
    
    [list addItemsObject:item];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (NSArray*)fetchLists {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *lists = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return lists;
}

- (void)updateItemFavorite:(ListItem*)item {
    ListItem *fetchedItem = [self fetchTargetItem:item];
    if (item.isFavorited) {
        fetchedItem.isFavorited = @(0);
    } else {
        fetchedItem.isFavorited = @(1);
    }
}

- (void)updateItemComplete:(ListItem*)item {
    ListItem *fetchedItem = [self fetchTargetItem:item];
    if (item.isComplete) {
        fetchedItem.isComplete = @(0);
    } else {
        fetchedItem.isComplete = @(1);
    }
}

# pragma mark -- private methods

- (ListItem*)fetchTargetItem:(ListItem*)item {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@", item];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return [results objectAtIndex:0];
}

- (void)setupCoreData {
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Lists.sqlite"];
    
    NSDictionary *options = @{NSPersistentStoreFileProtectionKey: NSFileProtectionComplete,
                              NSMigratePersistentStoresAutomaticallyOption:@YES};
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
    if (!store)
    {
        NSLog(@"Error adding persistent store. Error %@",error);
        
        NSError *deleteError = nil;
        if ([[NSFileManager defaultManager] removeItemAtURL:url error:&deleteError])
        {
            error = nil;
            store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
        }
        
        if (!store)
        {
            // Also inform the user...
            NSLog(@"Failed to create persistent store. Error %@. Delete error %@",error,deleteError);
            abort();
        }
    }
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = psc;
}

@end
