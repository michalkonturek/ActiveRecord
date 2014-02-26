//
//  NSPersistentStoreCoordinator+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSPersistentStoreCoordinator+AR.h"

#import "NSManagedObjectModel+AR.h"

@implementation NSPersistentStoreCoordinator (AR)

static dispatch_once_t pred;
static NSPersistentStoreCoordinator *sharedInstance;

+ (instancetype)sharedInstance {
    
    dispatch_once(&pred, ^{
        id fileName = [self defaultStoreName];
        id storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
        sharedInstance = [self createWithURL:storeURL withType:NSSQLiteStoreType];
    });
    
    return sharedInstance;
}

+ (instancetype)sharedInstanceWithAutoMigration {
    
    dispatch_once(&pred, ^{
        NSString *fileName = [self defaultStoreName];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
        sharedInstance = [self createWithAutoMigrationWithURL:storeURL withType:NSSQLiteStoreType];
    });
    
    return sharedInstance;
}

+ (instancetype )createWithURL:(NSURL *)storeURL withType:(NSString *)storeType {
    return [self createWithURL:storeURL withType:storeType withOptions:nil];
}

+ (instancetype)createWithAutoMigrationWithURL:(NSURL *)storeURL withType:(NSString *)storeType {
    id options = [self autoMigrationOptions];
    return [self createWithURL:storeURL withType:storeType withOptions:options];
}

+ (instancetype)createWithURL:(NSURL *)storeURL
                     withType:(NSString *)storeType withOptions:(NSDictionary *)options {
    
    id error = nil;
    id model = [NSManagedObjectModel managedObjectModel];
    id instance = [[self alloc] initWithManagedObjectModel:model];
    
    id store = [instance addPersistentStoreWithType:storeType
                                      configuration:nil URL:storeURL options:options error:&error];
    
    if (!store) {
#if DEBUG
        NSLog(@"*** Persistance Store Error: %@, %@, %@",
              error, [error userInfo], [error localizedDescription]);
        abort();
#endif
    }
    
    if (!instance) {
        id format = @"Could not create store of type %@ at URL %@ (Error: %@)";
        [NSException raise:NSInternalInconsistencyException
                    format:format, storeType, [storeURL absoluteURL], [error localizedDescription]];
    }
    
    return instance;
}

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

+ (NSDictionary *)autoMigrationOptions {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
            nil];
}

+ (NSString *)defaultStoreName {
    return @"data.sqlite";
}

@end
