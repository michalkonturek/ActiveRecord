//
//  NSManagedObject+AR_Finders.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (AR_Finders)

+ (instancetype)objectWithID:(NSNumber *)objectID;
//+ (instancetype)objectWithName:(NSString *)name;
+ (instancetype)objectWithPredicate:(NSPredicate *)predicate;
+ (instancetype)objectWithMaxValueForAttribute:(NSString *)attribute;
+ (instancetype)objectWithMinValueForAttribute:(NSString *)attribute;

+ (NSArray *)orderedAscendingBy:(NSString *)key;
+ (NSArray *)orderedDescendingBy:(NSString *)key;
+ (NSArray *)orderedBy:(NSSortDescriptor *)descriptor;

+ (NSArray *)objects;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors;

@end
