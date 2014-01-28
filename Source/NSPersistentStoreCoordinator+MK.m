//
//  NSPersistentStoreCoordinator+MK.m
//  MKCoreData
//
//  Created by Michal Konturek on 01/06/2011.
//  Copyright (c) 2011 Michal Konturek. All rights reserved.
//

#import "NSPersistentStoreCoordinator+MK.h"
#import "NSManagedObjectModel+MK.h"


@implementation NSPersistentStoreCoordinator (MK)

static dispatch_once_t pred;
static NSPersistentStoreCoordinator *sharedPersistentStoreCoordinator;

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    dispatch_once(&pred, ^{
        NSString *fileName = @"Data.sqlite";
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
        sharedPersistentStoreCoordinator = [self persistentStoreCoordinatorWithURL:storeURL withType:NSSQLiteStoreType];
    });
    
    return sharedPersistentStoreCoordinator;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithAutoMigration {
    
    dispatch_once(&pred, ^{
        NSString *fileName = @"Data.sqlite";
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
        sharedPersistentStoreCoordinator = [self persistentStoreCoordinatoWithAutoMigrationrWithURL:storeURL withType:NSSQLiteStoreType];
    });
    
    return sharedPersistentStoreCoordinator;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithURL:(NSURL *)storeURL withType:(NSString *)storeType {        
    return [self persistentStoreCoordinatorWithURL:storeURL withType:storeType withOptions:nil];
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatoWithAutoMigrationrWithURL:(NSURL *)storeURL withType:(NSString *)storeType {
    NSDictionary *options = [self autoMigrationOptions];
    return [self persistentStoreCoordinatorWithURL:storeURL withType:storeType withOptions:options];
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithURL:(NSURL *)storeURL 
                                                           withType:(NSString *)storeType 
                                                        withOptions:(NSDictionary *)options {
//    if (sharedPersistentStoreCoordinator != nil) [sharedPersistentStoreCoordinator release]; ARC
    
    NSError *error = nil;
    NSManagedObjectModel *model = [NSManagedObjectModel managedObjectModel];
    sharedPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    if (![sharedPersistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:options error:&error]) {
//        [sharedPersistentStoreCoordinator release]; ARC
        sharedPersistentStoreCoordinator = nil;
#if DEBUG
        NSLog(@"*** Persistance Store Error: %@, %@, %@", error, [error userInfo], [error localizedDescription]);
        abort();
#endif
    }
    
    if (sharedPersistentStoreCoordinator == nil) {
        NSString *format = @"Could not setup persistance store of type %@ at URL %@ (Error: %@)";
        [NSException raise:NSInternalInconsistencyException format:format, storeType, [storeURL absoluteURL], [error localizedDescription]];
    }
    
    return sharedPersistentStoreCoordinator;
}

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSDictionary *)autoMigrationOptions {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, 
            nil];
}


@end

