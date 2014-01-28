//
//  MKManagedObject.m
//  MKCoreData
//
//  Created by Michal Konturek on 01/06/2011.
//  Copyright (c) 2011 Michal Konturek. All rights reserved.
//

#import "MKManagedObject.h"
#import "NSManagedObjectContext+MK.h"


static BOOL debugOutput;


@implementation MKManagedObject



#pragma mark - DEBUG

+ (void)initialize {
    debugOutput = NO;
}

+ (void)debug_startPrintingDebugOutput {
    debugOutput = YES;
}

+ (void)debug_stopPrintingDebugOutput {
    debugOutput = NO;
}

+ (BOOL)debug_isDebugOutputPrinted {
    return debugOutput;
}


- (void)willTurnIntoFault {
    [super willTurnIntoFault];
    
    if ([self observationInfo]) {
        DLog(@"");
        DLog(@"%@ has observers:\n%@", [self objectID], [self observationInfo]);
    }
}

- (void)debug_printObject {
    [self debug_printObjectAttributes];
    [self debug_printRelationships];
}

- (void)debug_printObjectAttributes {
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *key in [attributes allKeys]) {
        id value = [self valueForKey:key];
        MLog(@"%@: %@", key, value);
    }
}

- (void)debug_printRelationships {
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    for (NSString *key in [relationships allKeys]) {
        
        NSRelationshipDescription *relationshipDescription = [relationships objectForKey:key];
        if ([relationshipDescription isToMany]) {
            NSSet *relatedObjectSet = [self mutableSetValueForKey:key];
            for (id relatedObject in relatedObjectSet) {
                [relatedObject debug_printObject];
            }
        } else {
            id relatedObject = [self valueForKey:key];
            [relatedObject debug_printObject];
        }
    }
}


#pragma mark - Entity Methods

+ (NSEntityDescription *)entityDescription {
    NSManagedObjectContext *ctx = [[self class] managedObjectContext];
    NSString *entityName = [[self class] entityName];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:ctx];
}

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (MKManagedObject *)createObjectWithID:(NSNumber *)objectID {
    MKManagedObject *object = [self objectWithID:objectID];
    if (!object) object = [self createObject];
    [object setValue:objectID forKey:@"uid"];
    return object;
}

+ (MKManagedObject *)createObject {
    NSManagedObjectContext *ctx = [[self class] managedObjectContext];
    NSString *entityName = [[self class] entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:ctx];
}

- (void)deleteObject {
//    [[self class] deleteObject:self];
    
    NSManagedObjectContext *ctx = [[self class] managedObjectContext];
    [self deleteObjectInManagedObjectContext:ctx];
}

- (void)deleteObjectInManagedObjectContext:(NSManagedObjectContext *)context {
    
    // MKTODO: overview and change it back as it was as it was not broken.
    
//    // NOTE: this method is broken
//    [context deleteObject:self];
//    [[self class] commitInContext:context];
    
    [[self class] deleteObject:self];
}

+ (void)deleteObject:(NSManagedObject *)object {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", object];
//    [self deleteAllObjectsWithPredicate:predicate];

    NSManagedObjectContext *ctx = [[self class] managedObjectContext];
    [self deleteObject:object inManagedObjectContext:ctx];
}

+ (void)deleteObject:(NSManagedObject *)object inManagedObjectContext:(NSManagedObjectContext *)context {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", object];
    [self deleteAllObjectsWithPredicate:predicate inManagedObjectContext:context];
}

+ (void)deleteAllObjects {
    [[self class] deleteAllObjectsWithPredicate:nil];
}

+ (void)deleteAllObjectsWithPredicate:(NSPredicate *)predicate {
    NSManagedObjectContext *ctx = [[self class] managedObjectContext];
    [[self class] deleteAllObjectsWithPredicate:predicate inManagedObjectContext:ctx];
}

+ (void)deleteAllObjectsWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context {
    
    // MKTODO: Overview this
//    NSArray *objects = [self objectsWithPredicate:predicate];
//    NSMutableArray *objects = [NSMutableArray arrayWithArray:[self objectsWithPredicate:predicate]];
    NSMutableArray *objects = [[self objectsWithPredicate:predicate] mutableCopy];
    for (NSManagedObject *object in objects) {
        [context deleteObject:object];
    }
    
    [[self class] commitInContext:context];
}


#pragma mark - Validation Methods

- (BOOL)isValidated {
    return ([self validate] == nil) ? YES : NO;
}

// MKTODO: rename it to validationErrorString
- (NSString *)validate {
    NSString *reason = [NSString stringWithFormat:@"You must override ""%@"" in a subclass", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}


#pragma mark - Query Methods

+ (BOOL)hasAnyObjects {
    return [self hasAnyObjectsWithPredicate:nil];
}

+ (BOOL)hasAnyObjectsWithPredicate:(NSPredicate *)predicate {
    MKManagedObject *object = [self firstWithPredicate:predicate];
    return (object != nil) ? YES : NO;
}


#pragma mark - Utility Methods

- (MKManagedObject *)cloneObject {
    MKManagedObject *cloned = [[self class] createObject];
    MKManagedObject *source = self;
    
    NSDictionary *attributes = [[[self class] entityDescription] attributesByName];
    for (NSString *attribute in attributes) {
        [cloned setValue:[source valueForKey:attribute] forKey:attribute];
    }
    
    // MKTODO: also clone relationships
    
    return cloned;
}

- (void)commit {
    [[self class] commit];
}


#pragma mark - Temporary ID

- (BOOL)hasTemporaryID {
    NSNumber *ID = [self valueForKey:@"uid"];
    return (ID != nil) ? ([ID integerValue] <= 0) : NO;
}

- (void)assignTemporaryID {
    NSString *key = @"uid";
    NSNumber *tempID = [self generateID];
    [self setValue:tempID forKey:key];
    
    if ([[self class] debug_isDebugOutputPrinted]) DLog(@"*** Generated ID: %@", tempID);
}

- (NSNumber *)generateID {
    static NSInteger defaultID = -1;
    static NSString *key = @"uid";
    MKManagedObject *object = [[self class] objectWithMinValueForAttribute:key];
    
    NSNumber *result = nil;
    if (object != nil) {
        result = [object valueForKey:key];
        
        // method was called on an object that was created by the server side
        if (result != nil && [result integerValue] > 0) return result;
        
        if (result != nil) {
            NSInteger newID = [result integerValue] + defaultID;
            return [NSNumber numberWithInteger:newID];
        }
    }
    
    return [NSNumber numberWithInteger:defaultID];
}


#pragma mark - Fetch Methods

+ (MKManagedObject *)objectWithID:(NSNumber *)objectID {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"uid == %@", objectID];
    return [[self class] objectWithPredicate:p];
}

+ (MKManagedObject *)objectWithName:(NSString *)name {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"name == %@", name];
    return [[self class] objectWithPredicate:p];
}

+ (MKManagedObject *)objectWithPredicate:(NSPredicate *)predicate {
    return [[self class] firstWithPredicate:predicate];
}

+ (MKManagedObject *)objectWithMaxValueForAttribute:(NSString *)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != nil", attribute];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:attribute ascending:NO];
    return [[self class] firstWithPredicate:predicate withSortDescriptor:descriptor];
}

+ (MKManagedObject *)objectWithMinValueForAttribute:(NSString *)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != nil", attribute];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:attribute ascending:YES];
    return [[self class] firstWithPredicate:predicate withSortDescriptor:descriptor];
}

+ (NSArray *)objects {
    return [[self class] objectsWithSortDescriptor:nil];
}

+ (NSArray *)objectsWithSortDescriptor:(NSSortDescriptor *)descriptor {
    return [[self class] objectsWithPredicate:nil withSortDescriptor:descriptor];
}

+ (NSArray *)objectsWithSortDescriptors:(NSArray *)descriptors {
    return [[self class] objectsWithPredicate:nil withSortDescriptors:descriptors];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate {
	return [[self class] objectsWithPredicate:predicate withSortDescriptor:nil];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor {
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    return [[self class] objectsWithPredicate:predicate withSortDescriptors:descriptors];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors {
    NSFetchRequest *fr = [[self class] fetchRequestWithPredicate:predicate withSortDescriptors:descriptors];
    return [[self class] executeFetchRequest:fr];
}

+ (NSArray *)distinctValuesForAttribute:(NSString *)attribute {
    return [[self class] distinctValuesForAttribute:attribute withPredicate:nil];
}

+ (NSArray *)distinctValuesForAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate {
    return [[self class] distinctValuesForAttribute:attribute withPredicate:predicate withSortDescriptor:nil];
}

+ (NSArray *)distinctValuesForAttribute:(NSString *)attribute withSortDescriptor:(NSSortDescriptor *)descriptor {
    return [[self class] distinctValuesForAttribute:attribute withPredicate:nil withSortDescriptor:descriptor];
}

+ (NSArray *)distinctValuesForAttribute:(NSString *)attribute 
                          withPredicate:(NSPredicate *)predicate 
                     withSortDescriptor:(NSSortDescriptor *)descriptor {
	NSArray *items = [[self class] objectsWithPredicate:predicate withSortDescriptor:descriptor];
	NSString *keyPath = [@"@distinctUnionOfObjects." stringByAppendingString:attribute];
	
	return [[items valueForKeyPath:keyPath] sortedArrayUsingSelector:@selector(compare:)];
}


#pragma mark - Helper Methods - Fetch Request

+ (NSFetchedResultsController *)resultsControllerWithPredicate:(NSPredicate *)predicate andSortDescriptor:(NSSortDescriptor *)descriptor {
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    return [[self class] resultsControllerWithPredicate:predicate andSortDescriptors:descriptors];
}

+ (NSFetchedResultsController *)resultsControllerWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)descriptors {
    NSManagedObjectContext *ctx = [[self class] managedObjectContext];
    NSFetchRequest *request = [[self class] fetchRequestWithPredicate:predicate withSortDescriptors:descriptors];

    NSError *error = nil;
    NSFetchedResultsController *result = nil;
    result = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                 managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];
    [result performFetch:&error];
    [[self class] handleError:error];
    
//    return [result autorelease];
    return result;
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor {
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    return [[self class] fetchRequestWithPredicate:predicate withSortDescriptors:descriptors];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors {    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSEntityDescription *ed = [[self class] entityDescription];
    [fr setEntity:ed];
    [fr setPredicate:predicate];
    [fr setSortDescriptors:descriptors];
//    return [fr autorelease];
    return fr;
}


#pragma mark - Helper Methods - Execution

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request {
    NSManagedObjectContext *ctx = [[self class] managedObjectContext];
    return [[self class] executeFetchRequest:request inManagedObjectContext:ctx];
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    [self handleError:error];
    return result;
}


#pragma mark - Managed Object Context Methods

+ (NSManagedObjectContext *)managedObjectContext {
    return [NSManagedObjectContext managedObjectContext];
}

+ (void)commit {
    NSManagedObjectContext *ctx = [[self class] managedObjectContext];
    [[self class] commitInContext:ctx];
}

+ (void)commitInContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    [context save:&error];
    [[self class] handleError:error];
//    @try {
//        NSError *error = nil;
//        [context save:&error];
//        [[self class] handleError:error];
//    }
//    @catch (NSException *exception) {
//        DLog(@"%@", exception);
//    }
//    @finally {
//    }
}

+ (void)rollback {
    NSManagedObjectContext *ctx = [self managedObjectContext];
    [self rollbackInContext:ctx];
}

+ (void)rollbackInContext:(NSManagedObjectContext *)context {
    [context rollback];
}


#pragma mark - Utility Methods

+ (MKManagedObject *)firstWithPredicate:(NSPredicate *)predicate {
    return [[self class] firstWithPredicate:predicate withSortDescriptor:nil];
}

+ (MKManagedObject *)firstWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor {
    NSArray *result = [[self class] objectsWithPredicate:predicate withSortDescriptor:descriptor];
    
    if (result != nil && [result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

+ (void)handleError:(NSError *)error {
    if (error != nil) {
        NSLog(@"*** %@ : %@ : %@", [self class], NSStringFromSelector(_cmd), [error localizedDescription]);
    }
}


@end


