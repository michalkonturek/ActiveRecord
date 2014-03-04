//
//  NSPredicate+AR.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSPredicate+AR.h"

#import <MKFoundationKit/NSArray+MK_Block.h>
#import <MKFoundationKit/NSDictionary+MK_Block.h>

@implementation NSPredicate (AR)

+ (instancetype)and:(NSArray *)conditions {
    id items = [conditions mk_map:^id(id item) {
        return [self createFrom:item];
    }];
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:items];
}

+ (instancetype)or:(NSArray *)conditions {
    id items = [conditions mk_map:^id(id item) {
        return [self createFrom:item];
    }];
    
    return [NSCompoundPredicate orPredicateWithSubpredicates:items];
}

+ (instancetype)and:(id)cond1 :(id)cond2 {
    return [cond1 and:cond2];
}

+ (instancetype)or:(id)cond1 :(id)cond2 {
    return [cond1 or:cond2];
}

+ (instancetype)createFrom:(id)object {
    if ([object isKindOfClass:[self class]]) return object;
    if ([object isKindOfClass:[NSString class]]) return [self predicateWithFormat:object];
    if ([object isKindOfClass:[NSDictionary class]]) return [self _createFromDictionary:object];
    return nil;
}

+ (instancetype)_createFromDictionary:(NSDictionary *)object {
    id items = [NSMutableArray array];
    [object enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [items addObject:[NSPredicate predicateWithFormat:@"%K == %@", key, obj]];
    }];
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:items];
}

- (instancetype)and:(id)condition {
    id predicate = [[self class] createFrom:condition];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[self, predicate]];
}

- (instancetype)or:(id)condition {
    id predicate = [[self class] createFrom:condition];
    return [NSCompoundPredicate orPredicateWithSubpredicates:@[self, predicate]];}

@end
