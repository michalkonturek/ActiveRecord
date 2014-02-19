//
//  NSFetchRequest+ActiveRecord.h
//  ActiveRecord
//
//  Created by Michal Konturek on 19/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (ActiveRecord)

+ (instancetype)createWithPredicate:(NSPredicate *)predicate
                 withSortDescriptor:(NSSortDescriptor *)descriptor;

+ (instancetype)createWithPredicate:(NSPredicate *)predicate
                withSortDescriptors:(NSArray *)descriptors;

@end
