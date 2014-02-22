//
//  NSManagedObjectContext+ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (ActiveRecord)

+ (NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObjectContext *)mainManagedObjectContext;
+ (NSManagedObjectContext *)backgroundManagedObjectContext;

+ (void)resetBackgroundManagedObjectContext;
+ (void)setBackgroundManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)debug_print;

@end
