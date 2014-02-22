//
//  NSManagedObject+ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ActiveRecord)

//+ (instancetype)createObjectWithID:(NSNumber *)objectID;
+ (instancetype)createObject;

+ (NSEntityDescription *)entityDescription;
+ (NSString *)entityName;

+ (NSString *)primaryKey;


+ (void)deleteAll;


+ (NSArray *)objects;

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors;


- (void)delete;

@end
