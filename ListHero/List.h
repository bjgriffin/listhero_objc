//
//  List.h
//  CalendarDraw
//
//  Created by BJ Griffin on 6/14/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface List : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *items;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
