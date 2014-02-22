//
//  NSManagedObjectContext+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObjectContext+ActiveRecord.h"

#import "NSPersistentStoreCoordinator+ActiveRecord.h"

static NSManagedObjectContext *_mainManagedObjectContext;
static NSManagedObjectContext *_backgroundManagedObjectContext = nil;

@implementation NSManagedObjectContext (ActiveRecord)

+ (NSManagedObjectContext *)MK_sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] init];
        NSPersistentStoreCoordinator *storeCoordinator = [NSPersistentStoreCoordinator persistentStoreCoordinatorWithAutoMigration];
        [_mainManagedObjectContext setPersistentStoreCoordinator:storeCoordinator];
    });
    
    return _mainManagedObjectContext;
}

+ (NSManagedObjectContext *)managedObjectContext {
    static dispatch_once_t onceToken;
    
    if ([NSThread isMainThread]) {
        dispatch_once(&onceToken, ^{
            _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            NSPersistentStoreCoordinator *storeCoordinator = [NSPersistentStoreCoordinator persistentStoreCoordinatorWithAutoMigration];
            [_mainManagedObjectContext setPersistentStoreCoordinator:storeCoordinator];
        });
        
        return _mainManagedObjectContext;
    }
    
    if (_backgroundManagedObjectContext == nil) [self _createBackgroundManagedObjectContext];
    return _backgroundManagedObjectContext;
}

+ (void)_createBackgroundManagedObjectContext {
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [NSManagedObjectContext setBackgroundManagedObjectContext:ctx];
    [ctx setParentContext:[NSManagedObjectContext mainManagedObjectContext]];
}

+ (void)resetBackgroundManagedObjectContext {
    [self setBackgroundManagedObjectContext:nil];
}

+ (void)setBackgroundManagedObjectContext:(NSManagedObjectContext *)context {
    if (context == _backgroundManagedObjectContext) return;
    
//    [context retain];
//    [_backgroundManagedObjectContext release];
    _backgroundManagedObjectContext = context;
}

+ (NSManagedObjectContext *)mainManagedObjectContext {
    return _mainManagedObjectContext;
}

+ (NSManagedObjectContext *)backgroundManagedObjectContext {
    return _backgroundManagedObjectContext;
}

+ (void)debug_print {
    NSLog(@"Main context: %@", _mainManagedObjectContext);
    NSLog(@"Background context: %@", _backgroundManagedObjectContext);
}


@end
