//
//  ARTypeConverter.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "ARConverter.h"

#import "NSManagedObject+AR.h"
#import "NSManagedObject+AR_Finders.h"
#import "NSManagedObject+AR_Serialization.h"

//#import <MKFoundationKit/NSDate+MK.h>

/*
 This class is responsible for fixing JSON with incorrect types,
 i.e. numbers are passed as strings.
 
 TODO: anyone should be able to add its own converter
 */

@implementation ARConverter

+ (instancetype)create {
    return [[self alloc] init];
}

- (NSManagedObject *)convert:(id)object toMatchRelationship:(NSRelationshipDescription *)description {
    
    if ([object isKindOfClass:[NSManagedObject class]]) return object;
    
    Class klass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
    
    if ([object isKindOfClass:[NSDictionary class]]) return [klass createOrUpdateWithData:object];
    if ([object isKindOfClass:[NSNumber class]]) return [klass objectWithID:object];
    
    if ([object isKindOfClass:[NSString class]])
        return [klass objectWithID:[self convertNSStringToNSNumber:object]];
//        return [klass objectWithID:[[ARTypeConverter create] convertNSStringToNSNumber:object]];
    
    return nil;
}

- (id)convert:(id)value toAttributeType:(NSAttributeType)type {
    if (![value isKindOfClass:[NSString class]]) return value;
    return [self convertString:value toAttributeType:type];
}

- (id)convertString:(NSString *)value toAttributeType:(NSAttributeType)type {
    switch (type) {
        case NSStringAttributeType:
            return value;
            break;
        case NSInteger16AttributeType:
            return [self convertNSStringToNSNumber:value];
            break;
        case NSInteger32AttributeType:
            return [self convertNSStringToNSNumber:value];
            break;
        case NSInteger64AttributeType:
            return [self convertNSStringToNSNumber:value];
            break;
//        case NSDateAttributeType:
//            return [NSDate mk_dateFromString:value];
//            break;
        default:
            return nil;
            break;
    }
}

- (NSNumber *)convertNSStringToNSNumber:(NSString *)value {
    if (!value) return nil;
    if ([[NSNull null] isEqual:value]) return nil;
    
    @try {
        return @([value longLongValue]);
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (id)convertNilToNSNull:(id)value {
    if (!value) return [NSNull null];
    return value;
}

- (id)convertNSNullToNil:(id)value {
    if ([[NSNull null] isEqual:value]) return nil;
    return value;
}

@end
