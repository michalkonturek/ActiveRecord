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

#import "NSManagedObject+ActiveRecord.h"
#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_FetchRequest.h"

@interface ActiveRecord : NSObject

@end
