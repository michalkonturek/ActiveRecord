//
//  NSManagedObject+NSFetchRequest.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR_Request.h"

#import "NSFetchRequest+AR.h"
#import "NSManagedObject+AR.h"

@implementation NSManagedObject (AR_Request)

+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate
                      withSortDescriptor:(NSSortDescriptor *)descriptor {
    id descriptors = (descriptor != nil) ? @[descriptor] : nil;
    return [self requestWithPredicate:predicate withSortDescriptors:descriptors];
}

+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate
                     withSortDescriptors:(NSArray *)descriptors {
    
    id request = [NSFetchRequest createWithPredicate:predicate withSortDescriptors:descriptors];
    [request setEntity:[self entityDescription]];
    return request;
}

@end
