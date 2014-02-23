//
//  NSManagedObject+AR_Finders.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (AR_Finders)

+ (NSArray *)objects;

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors;

//+ (NSArray *)objectsSortedBy:(NSString *)attribute
+ (NSArray *)objectsWithSortDescriptor:(NSSortDescriptor *)descriptor;

@end
