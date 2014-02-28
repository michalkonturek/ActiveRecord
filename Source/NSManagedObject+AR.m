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

+ (instancetype)createWithAutoID {
    id object = [self create];
    [object assignAutoID];
    return object;
}

//+ (NSNumber *)_autoGenerateID {
//    id pk = @1;
//    
//    id object = [self objectWithMaxValueFor:[self primaryKey]];
//    if (object) {
//        id max = [object valueForKey:[self primaryKey]];
//        
//        if ((max != nil) && ([max integerValue] > 0)) {
//            pk = @([max integerValue] + 1);
//        }
//    }
//    
//    return pk;
//}

- (void)assignAutoID {
    id key = [[self class] primaryKey];
    id pk = [self _autoGenerateID];
    [self setValue:pk forKey:key];
}

- (NSNumber *)_autoGenerateID {
    id defaultID = @1;
    id key = [[self class] primaryKey];
    
    id pk = [self valueForKey:key];
    if ([pk integerValue] > 0) return pk;
    
    id object = [[self class] objectWithMaxValueFor:key];
    if (object) {
        id max = [object valueForKey:key];
        
        if (!max) return defaultID;
        if (![max integerValue] > 0) return defaultID;
        if ([max integerValue] == [pk integerValue]) return pk;
        
        return @([max integerValue] + 1);
    }
    
    return defaultID;
}

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
