//
//  NSManagedObjectContext+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObjectContext+AR.h"

#import "NSPersistentStoreCoordinator+AR.h"

static NSManagedObjectContext *_foregroundContext;
static NSManagedObjectContext *_backgroundContext;

@implementation NSManagedObjectContext (AR)

+ (instancetype)managedObjectContext {
    static dispatch_once_t onceToken;
    
    if ([NSThread isMainThread]) {
        dispatch_once(&onceToken, ^{
            _foregroundContext = [[self alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            id coordinator = [NSPersistentStoreCoordinator sharedInstanceWithAutoMigration];
            [_foregroundContext setPersistentStoreCoordinator:coordinator];
        });
        
        return _foregroundContext;
    }
    
    if (_backgroundContext == nil) [self _createBackgroundContext];
    return _backgroundContext;
}

+ (void)_createBackgroundContext {
    id context = [[self alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [NSManagedObjectContext setBackgroundContext:context];
    [context setParentContext:[NSManagedObjectContext foregroundContext]];
}

+ (void)removeBackgroundContext {
    [self setBackgroundContext:nil];
}

+ (void)setBackgroundContext:(NSManagedObjectContext *)context {
    if (context == _backgroundContext) return;
    _backgroundContext = context;
}

+ (instancetype)foregroundContext {
    return _foregroundContext;
}

+ (instancetype)backgroundContext {
    return _backgroundContext;
}

//+ (void)debug_print {
//    NSLog(@"Main context: %@", _mainContext);
//    NSLog(@"Background context: %@", _backgroundContext);
//}

@end
