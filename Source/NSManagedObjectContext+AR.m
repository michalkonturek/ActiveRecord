//
//  NSManagedObjectContext+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObjectContext+AR.h"

#import "NSPersistentStoreCoordinator+AR.h"

static NSManagedObjectContext *_mainContext;
static NSManagedObjectContext *_backgroundContext;

@implementation NSManagedObjectContext (AR)

+ (instancetype)managedObjectContext {
    static dispatch_once_t onceToken;
    
    if ([NSThread isMainThread]) {
        dispatch_once(&onceToken, ^{
            _mainContext = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            id coordinator = [NSPersistentStoreCoordinator persistentStoreCoordinatorWithAutoMigration];
            [_mainContext setPersistentStoreCoordinator:coordinator];
        });
        
        return _mainContext;
    }
    
    if (_backgroundContext == nil) [self _createBackgroundContext];
    return _backgroundContext;
}

+ (void)_createBackgroundContext {
    id context = [[self alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [NSManagedObjectContext setBackgroundContext:context];
    [context setParentContext:[NSManagedObjectContext mainContext]];
}

+ (void)removeBackgroundContext {
    [self setBackgroundContext:nil];
}

// TODO: remove ?
+ (void)setBackgroundContext:(NSManagedObjectContext *)context {
    if (context == _backgroundContext) return;
    
//    [context retain];
//    [_backgroundManagedObjectContext release];
    _backgroundContext = context;
}

+ (instancetype)mainContext {
    return _mainContext;
}

+ (instancetype)backgroundContext {
    return _backgroundContext;
}

+ (void)debug_print {
    NSLog(@"Main context: %@", _mainContext);
    NSLog(@"Background context: %@", _backgroundContext);
}

@end
