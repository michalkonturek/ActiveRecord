//
//  NSManagedObjectContext+MK.h
//  MKCoreData
//
//  Created by Michal Konturek on 01/06/2011.
//  Copyright (c) 2011 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NSManagedObjectContext (MK)

+ (NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObjectContext *)mainManagedObjectContext;
+ (NSManagedObjectContext *)backgroundManagedObjectContext;

+ (void)resetBackgroundManagedObjectContext;
+ (void)setBackgroundManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)debug_print;

@end

