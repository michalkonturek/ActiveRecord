//
//  NSManagedObject+AR_Serialization.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR_Serialization.h"

#import "NSManagedObject+AR.h"
#import "NSManagedObject+AR_Finders.h"

@implementation NSManagedObject (AR_Serialization)

+ (instancetype)createOrUpdateObjectWithData:(NSDictionary *)data {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", [data objectForKey:@"uid"]];
    return [[self class] createOrUpdateObjectWithData:data usingPredicate:predicate];
}

+ (instancetype)createOrUpdateObjectWithData:(NSDictionary *)data usingPredicate:(NSPredicate *)predicate {
    
    id object = [[self class] objectWithPredicate:predicate];
    if (object == nil) {
        object = [[self class] createObject];
    }
    
    object = [[self class] updateObject:object withAttributesData:data];
    object = [[self class] updateObject:object withRelationshipsData:data];

    [[self class] commit];
    
    return object;
}

+ (instancetype)updateObject:(id)object withAttributesData:(NSDictionary *)data {
//    if ([self debug_isDebugOutputPrinted]) MLog(@"- - - - -");
    
    NSDictionary *attributes = [[object entity] attributesByName];
    for (NSString *attribute in [attributes allKeys]) {
        
        id value = [data objectForKey:attribute];
        if (((NSNull *)value != [NSNull null]) && (value != nil)) {
            NSAttributeType type = [[attributes objectForKey:attribute] attributeType];
            value = [MKTypeConverter convertValue:value toDataType:type];
            [object setValue:value forKey:attribute];
            
//            if ([self debug_isDebugOutputPrinted]) MLog(@"%@ : %@", attribute, value);
        }
    }
    
    return object;
}

+ (instancetype)updateObject:(id)object withRelationshipsData:(NSDictionary *)data {
    
    NSDictionary *relationships = [[object entity] relationshipsByName];
    for (NSString *relationship in [relationships allKeys]) {
        
        id relatedObject = [data objectForKey:relationship];
        if (relatedObject != nil) {
            
            // MKNOTE: I do not thing this statemen is usefull
            /* NOTE: NSNull is not accepted by attributes of NSManagedObject */
            relatedObject = [MKTypeConverter convertNSNullToNil:relatedObject];
            
            NSRelationshipDescription *description = [[[object entity] relationshipsByName] objectForKey:relationship];
            if ([description isToMany]) {
                
                if (relatedObject != nil && [relatedObject isKindOfClass:[NSArray class]]) {
                    NSMutableSet *relatedObjectSet = [object mutableSetValueForKey:relationship];
//                    NSMutableSet *relatedObjectSet = [NSMutableSet setWithSet:[object mutableSetValueForKey:relationship]];
                    
                    for (id __strong o in relatedObject) {
                        o = [[self class] transformRelatedObject:o toMatchRelationshipDescritpion:description];
                        [relatedObjectSet addObject:o];
                    }
                    
                    [object setValue:relatedObjectSet forKey:relationship];
                }
            } else {
                relatedObject = [[self class] transformRelatedObject:relatedObject toMatchRelationshipDescritpion:description];
                [object setValue:relatedObject forKey:relationship];
            }
        }
    }
    
    return object;
}

+ (instancetype)transformRelatedObject:(id)relatedObject toMatchRelationshipDescritpion:(NSRelationshipDescription *)description {
    
    if (![relatedObject isKindOfClass:[NSManagedObject class]]) {
        if ([relatedObject isKindOfClass:[NSNumber class]]) {
            NSNumber *objectID = relatedObject;
            Class destinationClass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
            relatedObject = [destinationClass objectWithID:objectID];
            
        } else if ([relatedObject isKindOfClass:[NSString class]]) {
            NSNumber *objectID = [MKTypeConverter convertNSStringToNSNumber:relatedObject];
            Class destinationClass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
            relatedObject = [destinationClass objectWithID:objectID];
            
        } else if ([relatedObject isKindOfClass:[NSDictionary class]]) {
            Class destinationClass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
            relatedObject = [destinationClass createOrUpdateObjectWithData:relatedObject];
        }
    }
    
//    if ([self debug_isDebugOutputPrinted]) MLog(@"*** RELATION: %@", [[description destinationEntity] managedObjectClassName]);
    
    return relatedObject;
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *key in [attributes allKeys]) {
        id value = [self valueForKey:key];
        [result setObject:value forKey:key];
    }
    
    return result;
}

@end
