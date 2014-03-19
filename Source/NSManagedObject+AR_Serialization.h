//
//  NSManagedObject+AR_Serialization.h
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (AR_Serialization)

+ (instancetype)createOrUpdateObjectWithData:(NSDictionary *)data;
+ (instancetype)createOrUpdateObjectWithData:(NSDictionary *)data
                              usingPredicate:(NSPredicate *)predicate;

+ (instancetype)updateObject:(id)object withData:(NSDictionary *)data;
+ (instancetype)updateObject:(id)object withAttributesData:(NSDictionary *)data;
+ (instancetype)updateObject:(id)object withRelationshipsData:(NSDictionary *)data;

+ (instancetype)transformRelatedObject:(id)relatedObject
        toMatchRelationshipDescritpion:(NSRelationshipDescription *)description;

- (NSDictionary *)dictionary;

@end
