//
//  NSManagedObject+AR_Context.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR_Context.h"

#import "NSManagedObjectContext+ActiveRecord.h"

@implementation NSManagedObject (AR_Context)

+ (void)commit {
    [self commitInContext:[self managedObjectContext]];
}

+ (void)commitInContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    [context save:&error];
    [self handleError:error];
}

+ (void)rollback {
    [self rollbackInContext:[self managedObjectContext]];
}

+ (void)rollbackInContext:(NSManagedObjectContext *)context {
    [context rollback];
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request {
    return [self executeFetchRequest:request inManagedObjectContext:[self managedObjectContext]];
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request
          inManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    [self handleError:error];
    return result;
}

+ (NSManagedObjectContext *)managedObjectContext {
    return [NSManagedObjectContext managedObjectContext];
}

+ (void)handleError:(NSError *)error {
    if (error != nil) {
        NSLog(@"*** %@ : %@ : %@",
              [self class], NSStringFromSelector(_cmd), [error localizedDescription]);
    }
}

@end
