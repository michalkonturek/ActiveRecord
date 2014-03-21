//
//  NSManagedObject+AR_Serialization.h
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (AR_Serialization)

+ (instancetype)createOrUpdateWithData:(NSDictionary *)data;
+ (instancetype)createOrUpdateWithData:(NSDictionary *)data
                        usingPredicate:(NSPredicate *)predicate;

+ (instancetype)update:(id)object withData:(NSDictionary *)data;
+ (instancetype)update:(id)object withAttributesData:(NSDictionary *)data;
+ (instancetype)update:(id)object withRelationshipsData:(NSDictionary *)data;

+ (instancetype)transform:(id)object toMatchRelationship:(NSRelationshipDescription *)description;

- (instancetype)updateWithData:(NSDictionary *)data;
- (instancetype)updateWithAttributesData:(NSDictionary *)data;
- (instancetype)updateWithRelationshipsData:(NSDictionary *)data;

- (NSDictionary *)dictionary;

@end
