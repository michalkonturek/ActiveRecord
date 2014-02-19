//
//  NSFetchRequest+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSFetchRequest+ActiveRecord.h"

@implementation NSFetchRequest (ActiveRecord)

+ (instancetype)createWithPredicate:(NSPredicate *)predicate
                 withSortDescriptor:(NSSortDescriptor *)descriptor {
    return [self createWithPredicate:predicate withSortDescriptors:@[descriptor]];
}

+ (instancetype)createWithPredicate:(NSPredicate *)predicate
                withSortDescriptors:(NSArray *)descriptors {
    id request = [[self alloc] init];
    [request setPredicate:predicate];
    [request setSortDescriptors:descriptors];
    return request;
}

@end
