//
//  NSPersistentStoreCoordinator+MK.h
//  MKCoreData
//
//  Created by Michal Konturek on 01/06/2011.
//  Copyright (c) 2011 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NSPersistentStoreCoordinator (MK)

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

