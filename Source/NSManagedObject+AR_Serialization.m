//
//  NSManagedObject+AR_Serialization.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR_Serialization.h"

#import "NSManagedObject+AR.h"
#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_Finders.h"

#import "NSPredicate+AR.h"

#import "ARTypeConverter.h"

@implementation NSManagedObject (AR_Serialization)

+ (instancetype)createOrUpdateWithData:(NSDictionary *)data {
    id pk = [self primaryKey];
    id value = [data objectForKey:pk];
    id predicate = [NSPredicate createFrom:@{pk: value}];
    return [self createOrUpdateWithData:data usingPredicate:predicate];
}

+ (instancetype)createOrUpdateWithData:(NSDictionary *)data
                        usingPredicate:(NSPredicate *)predicate {
    
    id object = [self objectWithPredicate:predicate];
    if (object == nil) object = [self create];
    
    object = [self update:object withData:data];

//    [self commit]; NOTE: this should not be here (background processing?)
    
    return object;
}

+ (instancetype)update:(id)object withData:(NSDictionary *)data {
    object = [self update:object withAttributesData:data];
    object = [self update:object withRelationshipsData:data];
    return object;
}

+ (instancetype)update:(id)object withAttributesData:(NSDictionary *)data {
//    if ([self debug_isDebugOutputPrinted]) MLog(@"- - - - -");
    
    NSDictionary *attributes = [[object entity] attributesByName];
    for (NSString *attribute in [attributes allKeys]) {
        
        id value = [data objectForKey:attribute];
        if (((NSNull *)value != [NSNull null]) && (value != nil)) {
            NSAttributeType type = [[attributes objectForKey:attribute] attributeType];
            value = [ARTypeConverter convertValue:value toDataType:type];
            [object setValue:value forKey:attribute];
            
//            if ([self debug_isDebugOutputPrinted]) MLog(@"%@ : %@", attribute, value);
        }
    }
    
    return object;
}

+ (instancetype)update:(id)object withRelationshipsData:(NSDictionary *)data {
    
    NSDictionary *relationships = [[object entity] relationshipsByName];
    for (NSString *relationship in [relationships allKeys]) {
        
        id relatedObject = [data objectForKey:relationship];
        if (relatedObject != nil) {
            
            // MKNOTE: I do not think this statemen is usefull
            /* NOTE: NSNull is not accepted by attributes of NSManagedObject */
            relatedObject = [ARTypeConverter convertNSNullToNil:relatedObject];
            
            NSRelationshipDescription *description = [[[object entity] relationshipsByName] objectForKey:relationship];
            if ([description isToMany]) {
                
                if (relatedObject != nil && [relatedObject isKindOfClass:[NSArray class]]) {
                    NSMutableSet *relatedObjectSet = [object mutableSetValueForKey:relationship];
//                    NSMutableSet *relatedObjectSet = [NSMutableSet setWithSet:[object mutableSetValueForKey:relationship]];
                    
                    for (id __strong o in relatedObject) {
                        o = [self transform:o toMatchRelationship:description];
                        [relatedObjectSet addObject:o];
                    }
                    
                    [object setValue:relatedObjectSet forKey:relationship];
                }
            } else {
                relatedObject = [self transform:relatedObject toMatchRelationship:description];
                [object setValue:relatedObject forKey:relationship];
            }
        }
    }
    
    return object;
}

+ (instancetype)transform:(id)object
      toMatchRelationship:(NSRelationshipDescription *)description {
    
    if (![object isKindOfClass:[NSManagedObject class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *objectID = object;
            Class destinationClass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
            object = [destinationClass objectWithID:objectID];
            
        } else if ([object isKindOfClass:[NSString class]]) {
            NSNumber *objectID = [ARTypeConverter convertNSStringToNSNumber:object];
            Class destinationClass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
            object = [destinationClass objectWithID:objectID];
            
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            Class destinationClass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
            object = [destinationClass createOrUpdateWithData:object];
        }
    }
    
//    if ([self debug_isDebugOutputPrinted]) MLog(@"*** RELATION: %@", [[description destinationEntity] managedObjectClassName]);
    
    return object;
}

- (NSDictionary *)dictionary {
    id result = [NSMutableDictionary dictionary];
    
    id attributes = [[self entity] attributesByName];
    for (NSString *key in [attributes allKeys]) {
        id value = [self valueForKey:key];
        if (value) [result setObject:value forKey:key];
    }
    
    return result;
}

@end
