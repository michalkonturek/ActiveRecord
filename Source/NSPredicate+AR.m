//
//  NSPredicate+AR.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSPredicate+AR.h"

#import <MKFoundationKit/NSArray+MK_Block.h>

@implementation NSPredicate (AR)

+ (instancetype)and:(NSArray *)conditions {
    id items = [conditions mk_map:^id(id item) {
        return [self createFrom:item];
    }];
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:items];
//    [[[[Student fetch] where:@""] and:@""] execute]
}

+ (instancetype)and:(id)cond1 :(id)cond2 {
    return [cond1 and:cond2];
}

+ (instancetype)or:(NSArray *)conditions {
    id items = [conditions mk_map:^id(id item) {
        return [self createFrom:item];
    }];
    
    return [NSCompoundPredicate orPredicateWithSubpredicates:items];
}

+ (instancetype)or:(id)cond1 :(id)cond2 {
    return [cond1 or:cond2];
}

+ (instancetype)createFrom:(id)object {
    if ([object isKindOfClass:[self class]]) return object;
    else if ([object isKindOfClass:[NSString class]]) return [self predicateWithFormat:object];
    return nil;
}

- (instancetype)and:(id)condition {
    id predicate = [[self class] createFrom:condition];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[self, predicate]];
}

- (instancetype)or:(id)condition {
    id predicate = [[self class] createFrom:condition];
    return [NSCompoundPredicate orPredicateWithSubpredicates:@[self, predicate]];}

@end
