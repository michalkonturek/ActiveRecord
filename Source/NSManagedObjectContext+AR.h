//
//  NSManagedObjectContext+ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (AR)

+ (instancetype)managedObjectContext;
+ (instancetype)mainContext;
+ (instancetype)backgroundContext;

+ (void)removeBackgroundContext;
+ (void)setBackgroundContext:(NSManagedObjectContext *)context;

//+ (void)debug_print;

@end
