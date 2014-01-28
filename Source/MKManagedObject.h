//
//  NSManagedObjectModel.h
//  MKCoreData
//
//  Created by Michal Konturek on 01/06/2011.
//  Copyright (c) 2011 Michal Konturek. All rights reserved.
//

#import "NSManagedObjectModel+MK.h"
#import "MKMacro+Debug.h"


@interface MKManagedObject : NSManagedObject 


#pragma mark - DEBUG

+ (void)debug_startPrintingDebugOutput;
+ (void)debug_stopPrintingDebugOutput;
+ (BOOL)debug_isDebugOutputPrinted;


#pragma mark - Entity Methods

+ (NSString *)entityName;
+ (NSEntityDescription *)entityDescription;


#pragma mark - Creation Methods

+ (MKManagedObject *)createObjectWithID:(NSNumber *)objectID;
+ (MKManagedObject *)createObject;

+ (void)deleteObject:(NSManagedObject *)object;
+ (void)deleteObject:(NSManagedObject *)object inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteAllObjects;
+ (void)deleteAllObjectsWithPredicate:(NSPredicate *)predicate;
+ (void)deleteAllObjectsWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context;


#pragma mark - Query Methods

+ (BOOL)hasAnyObjects;
+ (BOOL)hasAnyObjectsWithPredicate:(NSPredicate *)predicate;


#pragma mark - Extraction Methods

+ (MKManagedObject *)objectWithID:(NSNumber *)objectID;
+ (MKManagedObject *)objectWithName:(NSString *)name;
+ (MKManagedObject *)objectWithPredicate:(NSPredicate *)predicate;
+ (MKManagedObject *)objectWithMaxValueForAttribute:(NSString *)attribute;
+ (MKManagedObject *)objectWithMinValueForAttribute:(NSString *)attribute;

+ (NSArray *)objects;
+ (NSArray *)objectsWithSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)objectsWithSortDescriptors:(NSArray *)descriptors;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors;
+ (NSArray *)distinctValuesForAttribute:(NSString *)attribute;
+ (NSArray *)distinctValuesForAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate;
+ (NSArray *)distinctValuesForAttribute:(NSString *)attribute withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)distinctValuesForAttribute:(NSString *)attribute 
                          withPredicate:(NSPredicate *)predicate 
                     withSortDescriptor:(NSSortDescriptor *)descriptor;


#pragma mark - Helper Methods - Fetch Objects

+ (NSFetchedResultsController *)resultsControllerWithPredicate:(NSPredicate *)predicate andSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSFetchedResultsController *)resultsControllerWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)descriptors;
+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors;


#pragma mark - Helper Methods - Execution

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request;
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inManagedObjectContext:(NSManagedObjectContext *)context;


#pragma mark - Managed Object Context Methods

+ (NSManagedObjectContext *)managedObjectContext;
+ (void)commit;
+ (void)commitInContext:(NSManagedObjectContext *)context;
+ (void)rollback;
+ (void)rollbackInContext:(NSManagedObjectContext *)context;


#pragma mark - Helpet Methods - Extraction

+ (MKManagedObject *)firstWithPredicate:(NSPredicate *)predicate;
+ (MKManagedObject *)firstWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (void)handleError:(NSError *)error;



- (void)deleteObject;
- (void)deleteObjectInManagedObjectContext:(NSManagedObjectContext *)context;


#pragma mark - Object Printing

- (void)debug_printObject;
- (void)debug_printObjectAttributes;
- (void)debug_printRelationships;

/*
MKTODO:
 - this could be moved to validator object
 - something similar to validation pattern
 */
#pragma mark - Validation Methods

- (BOOL)isValidated;
- (NSString *)validate;


#pragma mark - Utility Methods

- (MKManagedObject *)cloneObject;
- (void)commit;


#pragma mark - Temporary ID

- (BOOL)hasTemporaryID;
- (void)assignTemporaryID;
- (NSNumber *)generateID;


@end

