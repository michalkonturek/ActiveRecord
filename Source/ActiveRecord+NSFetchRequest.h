//
//  ActiveRecord+NSFetchRequest.h
//  ActiveRecord
//
//  Created by Michal Konturek on 19/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "ActiveRecord.h"

@interface ActiveRecord (NSFetchRequest)

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                           withSortDescriptor:(NSSortDescriptor *)descriptor;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                          withSortDescriptors:(NSArray *)descriptors;

@end
