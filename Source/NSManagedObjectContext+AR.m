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
            id storeCoordinator = [NSPersistentStoreCoordinator persistentStoreCoordinatorWithAutoMigration];
            [_mainContext setPersistentStoreCoordinator:storeCoordinator];
        });
        
        return _mainContext;
    }
    
    if (_backgroundContext == nil) [self _createBackgroundManagedObjectContext];
    return _backgroundContext;
}

+ (void)_createBackgroundManagedObjectContext {
    NSManagedObjectContext *ctx = [[self alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [NSManagedObjectContext setBackgroundManagedObjectContext:ctx];
    [ctx setParentContext:[NSManagedObjectContext mainManagedObjectContext]];
}

+ (void)resetBackgroundManagedObjectContext {
    [self setBackgroundManagedObjectContext:nil];
}

+ (void)setBackgroundManagedObjectContext:(NSManagedObjectContext *)context {
    if (context == _backgroundContext) return;
    
//    [context retain];
//    [_backgroundManagedObjectContext release];
    _backgroundContext = context;
}

+ (instancetype)mainManagedObjectContext {
    return _mainContext;
}

+ (instancetype)backgroundManagedObjectContext {
    return _backgroundContext;
}

+ (void)debug_print {
    NSLog(@"Main context: %@", _mainContext);
    NSLog(@"Background context: %@", _backgroundContext);
}


@end
