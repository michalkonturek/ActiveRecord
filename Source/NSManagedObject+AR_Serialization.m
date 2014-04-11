//
//  NSManagedObject+AR_Serialization.m
//  ActiveRecord
//
//  Copyright (c) 2014 Michal Konturek
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSManagedObject+AR_Serialization.h"

#import "ActiveRecord.h"
#import "NSRelationshipDescription+AR.h"

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
    if (!object) object = [self create];
    
    object = [object updateWithData:data];
    
    return object;
}

- (instancetype)updateWithData:(NSDictionary *)data {
    return [[self updateWithAttributesData:data] updateWithRelationshipsData:data];
}

- (instancetype)updateWithAttributesData:(NSDictionary *)data {
    
    id converter = [[ActiveRecord registeredConverterClass] new];
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in [attributes allKeys]) {
        
        id value = [data objectForKey:attribute];
        if (((NSNull *)value != [NSNull null]) && (value != nil)) {
            NSAttributeType type = [[attributes objectForKey:attribute] attributeType];
            value = [converter convert:value toAttributeType:type];
            if (value) [self setValue:value forKey:attribute];
        }
    }
    
    return self;
}

- (instancetype)updateWithRelationshipsData:(NSDictionary *)data {
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    for (NSString *relationship in [relationships allKeys]) {
        
        id relatedObject = [data objectForKey:relationship];
        if (!relatedObject) continue;
        
        NSRelationshipDescription *description = [[[self entity] relationshipsByName] objectForKey:relationship];
        if ([description isToMany]) {
            
            if ([relatedObject isKindOfClass:[NSArray class]]) {
                NSMutableSet *relatedObjectSet = [self mutableSetValueForKey:relationship];
                
                for (id __strong item in relatedObject) {
                    item = [description managedObjectFrom:item];
                    if (item) [relatedObjectSet addObject:item];
                }
                
                [self setValue:relatedObjectSet forKey:relationship];
            }
        } else {
            relatedObject = [description managedObjectFrom:relatedObject];
            if (relatedObject) [self setValue:relatedObject forKey:relationship];
        }
    }
    
    return self;
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
