//
//  NSPersistentStoreCoordinator+ActiveRecord.m
//  ActiveRecord
//
//  Copyright (c) 2014 Michal Konturek
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSPersistentStoreCoordinator+AR.h"

#import "NSManagedObjectModel+AR.h"

static dispatch_once_t pred;
static NSPersistentStoreCoordinator *sharedInstance;

@implementation NSPersistentStoreCoordinator (AR)

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
