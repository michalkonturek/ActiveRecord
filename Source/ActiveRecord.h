//
//  ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 27/01/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "NSPersistentStoreCoordinator+AR.h"
#import "NSManagedObjectContext+AR.h"

#import "NSManagedObject+AR.h"
#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_Finders.h"
#import "NSManagedObject+AR_Request.h"

#import "NSPredicate+AR.h"

@interface ActiveRecord : NSObject

//+ (void)setup;
//+ (void)setupWithInMemoryStore;
//
//+ (void)cleanup;

@end
