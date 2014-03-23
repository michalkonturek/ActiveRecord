//
//  NSRelationshipDescription+AR.m
//  ActiveRecord
//
//  Created by Michal Konturek on 23/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSRelationshipDescription+AR.h"

#import "NSManagedObject+AR.h"
#import "NSManagedObject+AR_Finders.h"
#import "NSManagedObject+AR_Serialization.h"

#import "ARConverter.h"

@implementation NSRelationshipDescription (AR)

- (NSManagedObject *)managedObjectFrom:(id)object {
    if ([object isKindOfClass:[NSManagedObject class]]) return object;
    
    Class klass = NSClassFromString([[self destinationEntity] managedObjectClassName]);
    
    if ([object isKindOfClass:[NSDictionary class]]) return [klass createOrUpdateWithData:object];
    if ([object isKindOfClass:[NSNumber class]]) return [klass objectWithID:object];
    
    if ([object isKindOfClass:[NSString class]])
        return [klass objectWithID:[[ARConverter create] convertNSStringToNSNumber:object]];
    
    return nil;
}

@end
