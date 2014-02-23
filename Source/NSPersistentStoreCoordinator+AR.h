//
//  NSPersistentStoreCoordinator+ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSPersistentStoreCoordinator (AR)

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithAutoMigration;

+ (instancetype)createWithURL:(NSURL *)storeURL withType:(NSString *)storeType;
+ (instancetype)createWithAutoMigrationWithURL:(NSURL *)storeURL
                                      withType:(NSString *)storeType;
+ (instancetype)createWithURL:(NSURL *)storeURL
                     withType:(NSString *)storeType
                  withOptions:(NSDictionary *)options;

+ (NSURL *)applicationDocumentsDirectory;
+ (NSDictionary *)autoMigrationOptions;

@end
