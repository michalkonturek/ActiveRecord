//
//  NSManagedObject+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR.h"

#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_Finders.h"

#import <MKFoundationKit/NSArray+MK_Block.h>

@implementation NSManagedObject (AR)

+ (instancetype)createWithID:(NSNumber *)objectID {
    id object = [self objectWithID:objectID];
    if (!object) object = [self create];
    [object setValue:objectID forKey:[self primaryKey]];
    return object;
}

+ (instancetype)create {
    id context = [self managedObjectContext];
    id entityName = [self entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:context];
}

+ (NSEntityDescription *)entityDescription {
    id entityName = [self entityName];
    id context = [self managedObjectContext];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
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

- (void)delete {
    [self.managedObjectContext deleteObject:self];
}

@end
