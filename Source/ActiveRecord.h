//
//  ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 27/01/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MKFoundationKit/NSArray+MK_Block.h>
#import <MKFoundationKit/NSDictionary+MK_Block.h>

#import "NSManagedObject+AR.h"
#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_Finders.h"
#import "NSManagedObject+AR_Request.h"

#import "NSManagedObjectContext+AR.h"
#import "NSPersistentStoreCoordinator+AR.h"
#import "NSPredicate+AR.h"
#import "NSSortDescriptor+AR.h"

@interface ActiveRecord : NSObject

@end
