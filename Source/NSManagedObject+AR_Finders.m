//
//  NSManagedObject+AR_Finders.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR_Finders.h"

#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_Request.h"

@implementation NSManagedObject (AR_Finders)

+ (NSArray *)objects {
    return [self objectsWithPredicate:nil withSortDescriptors:nil];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate {
    return [self objectsWithPredicate:predicate withSortDescriptors:nil];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate
               withSortDescriptor:(NSSortDescriptor *)descriptor {
    return [self objectsWithPredicate:predicate withSortDescriptors:@[descriptor]];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate
              withSortDescriptors:(NSArray *)descriptors {
    id request = [self requestWithPredicate:predicate withSortDescriptors:descriptors];
    return [self executeFetchRequest:request];
}

@end
