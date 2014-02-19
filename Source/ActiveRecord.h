//
//  ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 27/01/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "NSPersistentStoreCoordinator+MK.h"
#import "NSManagedObjectContext+MK.h"

#import "MKManagedObject.h"

@interface ActiveRecord : NSManagedObject

+ (instancetype)createObjectWithID:(NSNumber *)objectID;
+ (instancetype)createObject;

+ (NSEntityDescription *)entityDescription;
+ (NSString *)entityName;

+ (NSString *)primaryKey;

@end
