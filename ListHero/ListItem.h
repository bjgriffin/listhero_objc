//
//  ListItem.h
//  CalendarDraw
//
//  Created by BJ Griffin on 6/14/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface ListItem : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * isFavorited;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *lists;
@end

@interface ListItem (CoreDataGeneratedAccessors)

- (void)addListsObject:(List *)value;
- (void)removeListsObject:(List *)value;
- (void)addLists:(NSSet *)values;
- (void)removeLists:(NSSet *)values;

@end
