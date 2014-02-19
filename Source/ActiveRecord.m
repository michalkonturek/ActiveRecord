//
//  ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 27/01/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "ActiveRecord.h"

#import "ActiveRecord+NSManagedObjectContext.h"

@implementation ActiveRecord

+ (instancetype)createObjectWithID:(NSNumber *)objectID {
    id object = [self objectWithID:objectID];
    if (!object) object = [self createObject];
    [object setValue:objectID forKey:[self primaryKey]];
    return object;
}

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

@end
