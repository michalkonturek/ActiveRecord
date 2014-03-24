//
//  NSRelationshipDescription+AR.h
//  ActiveRecord
//
//  Created by Michal Konturek on 23/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSRelationshipDescription (AR)

- (NSManagedObject *)managedObjectFrom:(id)object;

@end
