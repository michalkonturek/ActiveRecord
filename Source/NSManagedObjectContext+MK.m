//
//  NSManagedObjectContext+MK.m
//  MKCoreData
//
//  Created by Michal Konturek on 01/06/2011.
//  Copyright (c) 2011 Michal Konturek. All rights reserved.
//

#import "NSManagedObjectContext+MK.h"
#import "NSPersistentStoreCoordinator+MK.h"

#import "MKMacro+Debug.h"


static NSManagedObjectContext *_mainManagedObjectContext;
static NSManagedObjectContext *_backgroundManagedObjectContext = nil;


@implementation NSManagedObjectContext (MK)

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
    MLog(@"Main context: %@", _mainManagedObjectContext);
    MLog(@"Background context: %@", _backgroundManagedObjectContext);
}



/*
 
 http://developer.apple.com/library/ios/#releasenotes/DataManagement/RN-CoreData/_index.html#//apple_ref/doc/uid/TP40010637-CH1-SW1
 
 http://stackoverflow.com/questions/8305227/core-data-background-fetching-via-new-nsprivatequeueconcurrencytype
 http://stackoverflow.com/questions/11176275/when-to-use-core-datas-nsmainqueueconcurrencytype
 
 */


//+ (NSManagedObjectContext *)managedObjectContext {
//    static dispatch_once_t onceToken;
//    static NSManagedObjectContext *sharedManagedObjectContext;
//
//    dispatch_once(&onceToken, ^{
//        sharedManagedObjectContext = [[NSManagedObjectContext alloc] init];
//        NSPersistentStoreCoordinator *storeCoordinator = [NSPersistentStoreCoordinator persistentStoreCoordinatorWithAutoMigration];
//        [sharedManagedObjectContext setPersistentStoreCoordinator:storeCoordinator];
//    });
//
//    return sharedManagedObjectContext;
//}


@end

