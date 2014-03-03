//
//  NSMutableArray+RubySugar.m
//  RubySugar
//
//  Created by Michal Konturek on 26/12/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import "NSMutableArray+RubySugar.h"

@implementation NSMutableArray (RubySugar)

- (instancetype)rs_clear {
    [self removeAllObjects];
    return self;
}

- (instancetype)rs_delete:(id)object {
    if (![self containsObject:object]) return self;
    [self removeObject:object];
    return self;
}

- (instancetype)rs_deleteAt:(NSInteger)index {
    if (index >= (NSInteger)self.count) return self;
    if (index < 0) index = self.count + index;
    [self removeObjectAtIndex:index];
    return self;
}

- (id)rs_deleteIf:(BOOL (^)(id))block {
    if (!block) return [self objectEnumerator];
    
    for (id item in [self copy]) {
        if (block(item)) [self removeObject:item];
    }
    
    return self;
}

@end
