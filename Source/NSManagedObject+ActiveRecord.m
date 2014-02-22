//
//  NSManagedObject+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+ActiveRecord.h"

#import "NSManagedObject+AR_Context.h"

@implementation NSManagedObject (ActiveRecord)

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

- (void)delete {
    [self.managedObjectContext deleteObject:self];
}

@end
