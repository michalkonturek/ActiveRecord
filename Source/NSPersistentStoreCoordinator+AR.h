//
//  NSPersistentStoreCoordinator+ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSPersistentStoreCoordinator (AR)

+ (instancetype)persistentStoreCoordinator;
+ (instancetype)persistentStoreCoordinatorWithAutoMigration;
+ (instancetype)persistentStoreCoordinatorWithURL:(NSURL *)storeURL withType:(NSString *)storeType;
+ (instancetype)persistentStoreCoordinatoWithAutoMigrationrWithURL:(NSURL *)storeURL withType:(NSString *)storeType;
+ (instancetype)persistentStoreCoordinatorWithURL:(NSURL *)storeURL
                                                           withType:(NSString *)storeType
                                                        withOptions:(NSDictionary *)options;

+ (NSURL *)applicationDocumentsDirectory;
+ (NSDictionary *)autoMigrationOptions;

@end
