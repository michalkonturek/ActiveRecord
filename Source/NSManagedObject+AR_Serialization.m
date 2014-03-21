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
    
    NSDictionary *attributes = [[object entity] attributesByName];
    for (NSString *attribute in [attributes allKeys]) {
        
        id value = [data objectForKey:attribute];
        if (((NSNull *)value != [NSNull null]) && (value != nil)) {
            NSAttributeType type = [[attributes objectForKey:attribute] attributeType];
            value = [ARTypeConverter convertValue:value toDataType:type];
            if (value) [object setValue:value forKey:attribute];
        }
    }
    
    return object;
}

+ (instancetype)update:(id)object withRelationshipsData:(NSDictionary *)data {
    
    NSDictionary *relationships = [[object entity] relationshipsByName];
    for (NSString *relationship in [relationships allKeys]) {
        
        id relatedObject = [data objectForKey:relationship];
        if (!relatedObject) continue;

        NSRelationshipDescription *description = [[[object entity] relationshipsByName] objectForKey:relationship];
        if ([description isToMany]) {
            
            if ([relatedObject isKindOfClass:[NSArray class]]) {
                NSMutableSet *relatedObjectSet = [object mutableSetValueForKey:relationship];
                
                for (id __strong item in relatedObject) {
                    item = [self transform:item toMatchRelationship:description];
                    if (item) [relatedObjectSet addObject:item];
                }
                
                [object setValue:relatedObjectSet forKey:relationship];
            }
        } else {
            relatedObject = [self transform:relatedObject toMatchRelationship:description];
            if (relatedObject) [object setValue:relatedObject forKey:relationship];
        }
    }
    
    return object;
}

+ (instancetype)transform:(id)object toMatchRelationship:(NSRelationshipDescription *)description {

    if ([object isKindOfClass:[NSManagedObject class]]) return object;
    
    Class klass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
    
    if ([object isKindOfClass:[NSDictionary class]]) return [klass createOrUpdateWithData:object];
    if ([object isKindOfClass:[NSNumber class]]) return [klass objectWithID:object];
    
    if ([object isKindOfClass:[NSString class]])
        return [klass objectWithID:[ARTypeConverter convertNSStringToNSNumber:object]];
    
    return nil;
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
