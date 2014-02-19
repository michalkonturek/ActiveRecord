//
//  ActiveRecord+NSManagedObjectContext.h
//  ActiveRecord
//
//  Created by Michal Konturek on 19/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "ActiveRecord.h"

@interface ActiveRecord (NSManagedObjectContext)

+ (void)commit;
+ (void)commitInContext:(NSManagedObjectContext *)context;

+ (void)rollback;
+ (void)rollbackInContext:(NSManagedObjectContext *)context;

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request
          inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSManagedObjectContext *)managedObjectContext;

@end
