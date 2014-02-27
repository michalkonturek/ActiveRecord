//
//  NSManagedObject+AR_Finders.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (AR_Finders)

+ (BOOL)hasObjects;
+ (BOOL)hasObjects:(id)condition;
+ (BOOL)hasObjectsWithPredicate:(NSPredicate *)predicate;

+ (NSInteger)count;
+ (NSInteger)count:(id)condition;
+ (NSInteger)countWithPredicate:(NSPredicate *)predicate;

+ (instancetype)object:(id)condition;
+ (instancetype)objectWithID:(NSNumber *)objectID;
+ (instancetype)objectWithPredicate:(NSPredicate *)predicate;
+ (instancetype)objectWithMaxValueFor:(NSString *)attribute;
+ (instancetype)objectWithMinValueFor:(NSString *)attribute;

+ (NSArray *)orderedAscendingBy:(NSString *)key;
+ (NSArray *)orderedDescendingBy:(NSString *)key;
+ (NSArray *)orderedBy:(NSSortDescriptor *)descriptor;

+ (NSArray *)objects;
+ (NSArray *)objects:(id)condition;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors;

@end
