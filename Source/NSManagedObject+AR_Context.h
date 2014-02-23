//
//  NSManagedObject+AR_Context.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (AR_Context)

+ (void)commit;
+ (void)commitInContext:(NSManagedObjectContext *)context;

+ (void)rollback;
+ (void)rollbackInContext:(NSManagedObjectContext *)context;

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request
                       inContext:(NSManagedObjectContext *)context;

+ (NSManagedObjectContext *)managedObjectContext;

@end
