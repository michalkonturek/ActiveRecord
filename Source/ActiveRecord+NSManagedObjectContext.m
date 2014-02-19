//
//  ActiveRecord+NSManagedObjectContext.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "ActiveRecord+NSManagedObjectContext.h"

#import "NSManagedObjectContext+MK.h"

@implementation ActiveRecord (NSManagedObjectContext)

+ (void)commit {
    NSManagedObjectContext *ctx = [self managedObjectContext];
    [self commitInContext:ctx];
}

+ (void)commitInContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    [context save:&error];
    [self handleError:error];
}

+ (void)rollback {
    NSManagedObjectContext *ctx = [self managedObjectContext];
    [self rollbackInContext:ctx];
}

+ (void)rollbackInContext:(NSManagedObjectContext *)context {
    [context rollback];
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request {
    id ctx = [self managedObjectContext];
    return [self executeFetchRequest:request inManagedObjectContext:ctx];
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
