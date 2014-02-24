//
//  NSManagedObject+AR_Context.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR_Context.h"

#import "NSManagedObjectContext+AR.h"

@implementation NSManagedObject (AR_Context)

+ (void)commit {
    [self commitInContext:[self managedObjectContext]];
}

+ (void)commitInContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    [context save:&error];
    if (error) [self _printError:error];
}

+ (void)rollback {
    [self rollbackInContext:[self managedObjectContext]];
}

+ (void)rollbackInContext:(NSManagedObjectContext *)context {
    [context rollback];
}

+ (NSInteger)countForRequest:(NSFetchRequest *)request {
    return [self countForRequest:request inContext:[self managedObjectContext]];
}

+ (NSInteger)countForRequest:(NSFetchRequest *)request
                   inContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSInteger result = [context countForFetchRequest:request error:&error];
    if (error) [self _printError:error];
    return result;
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request {
    return [self executeFetchRequest:request inContext:[self managedObjectContext]];
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request
                       inContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error) [self _printError:error];
    return result;
}

+ (NSManagedObjectContext *)managedObjectContext {
    return [NSManagedObjectContext managedObjectContext];
}

+ (void)_printError:(NSError *)error {
    NSLog(@"*** %@ : %@ : %@",
          [self class], NSStringFromSelector(_cmd),
          [error localizedDescription]);
}

@end
