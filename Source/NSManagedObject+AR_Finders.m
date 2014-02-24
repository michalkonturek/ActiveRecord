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

#import "NSPredicate+AR.h"

@implementation NSManagedObject (AR_Finders)

+ (instancetype)objectWithID:(NSNumber *)objectID {
    id predicate = [NSPredicate predicateWithFormat:@"uid == %@", objectID];
    return [self objectWithPredicate:predicate];
}

+ (instancetype)objectWithPredicate:(NSPredicate *)predicate {
    return [self firstWithPredicate:predicate];
}

+ (instancetype)objectWithMaxValueFor:(NSString *)attribute {
    id predicate = [NSPredicate predicateWithFormat:@"%K != nil", attribute];
    id descriptor = [NSSortDescriptor sortDescriptorWithKey:attribute ascending:NO];
    return [self firstWithPredicate:predicate withSortDescriptor:descriptor];
}

+ (instancetype)objectWithMinValueFor:(NSString *)attribute {
    id predicate = [NSPredicate predicateWithFormat:@"%K != nil", attribute];
    id descriptor = [NSSortDescriptor sortDescriptorWithKey:attribute ascending:YES];
    return [self firstWithPredicate:predicate withSortDescriptor:descriptor];
}

+ (instancetype)firstWithPredicate:(NSPredicate *)predicate {
    return [self firstWithPredicate:predicate withSortDescriptor:nil];
}

+ (instancetype)firstWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor {
    id result = [self objectsWithPredicate:predicate withSortDescriptor:descriptor];
    if ([result count] > 0) return [result objectAtIndex:0];
    else return nil;
}

+ (NSArray *)orderedAscendingBy:(NSString *)key {
    return [self orderedBy:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]];
}

+ (NSArray *)orderedDescendingBy:(NSString *)key {
    return [self orderedBy:[NSSortDescriptor sortDescriptorWithKey:key ascending:NO]];
}

+ (NSArray *)orderedBy:(NSSortDescriptor *)descriptor {
    return [self objectsWithPredicate:nil withSortDescriptor:descriptor];
}

+ (NSArray *)objects {
    return [self objectsWithPredicate:nil withSortDescriptors:nil];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate {
    return [self objectsWithPredicate:predicate withSortDescriptors:nil];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor {
    id descriptors = (descriptor) ? @[descriptor] : nil;
    return [self objectsWithPredicate:predicate withSortDescriptors:descriptors];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors {
    id request = [self requestWithPredicate:predicate withSortDescriptors:descriptors];
    return [self executeFetchRequest:request];
}

@end






