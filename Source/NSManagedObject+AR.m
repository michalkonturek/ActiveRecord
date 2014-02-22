//
//  NSManagedObject+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR.h"

#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_FetchRequest.h"

#import <MKFoundationKit/NSArray+MK_Block.h>

@implementation NSManagedObject (AR)

//+ (instancetype)createObjectWithID:(NSNumber *)objectID {
//    id object = [self objectWithID:objectID];
//    if (!object) object = [self createObject];
//    [object setValue:objectID forKey:[self primaryKey]];
//    return object;
//}

+ (instancetype)createObject {
    id ctx = [self managedObjectContext];
    id entityName = [self entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:ctx];
}

+ (NSEntityDescription *)entityDescription {
    id entityName = [self entityName];
    id ctx = [self managedObjectContext];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:ctx];
}

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (NSString *)primaryKey {
    return @"uid";
}

+ (void)deleteAll {
    [[self objects] mk_each:^(id item) {
        [item delete];
    }];
}

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
    id request = [self fetchRequestWithPredicate:predicate withSortDescriptors:descriptors];
    return [self executeFetchRequest:request];
}


- (void)delete {
    [self.managedObjectContext deleteObject:self];
}

@end
