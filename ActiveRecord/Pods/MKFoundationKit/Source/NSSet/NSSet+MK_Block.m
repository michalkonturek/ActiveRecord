//
//  NSSet+MK_Block.m
//  MKFoundation
//
//  Created by Michal Konturek on 11/11/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import "NSSet+MK_Block.h"

#import "NSArray+MK_Block.h"

@implementation NSSet (MK_Block)

- (void)mk_apply:(void (^)(id item))block {
    [[self allObjects] mk_apply:block];
}

- (void)mk_each:(void (^)(id item))block {
    [[self allObjects] mk_each:block];
}

- (instancetype)mk_map:(id (^)(id item))selectorBlock {
    id result = [[self allObjects] mk_map:selectorBlock];
    return [[self class] setWithArray:result];
}

- (id)mk_match:(BOOL (^)(id item))conditionBlock {
    return [[self allObjects] mk_match:conditionBlock];
}

- (id)mk_reduce:(id)initial
      withBlock:(id (^)(id item, id aggregate))accumulatorBlock {
    return [[self allObjects] mk_reduce:initial withBlock:accumulatorBlock];
}

- (instancetype)mk_reject:(BOOL (^)(id item))conditionBlock {
    id result = [[self allObjects] mk_reject:conditionBlock];
    return [[self class] setWithArray:result];
}

- (instancetype)mk_select:(BOOL (^)(id item))conditionBlock {
    id result = [[self allObjects] mk_select:conditionBlock];
    return [[self class] setWithArray:result];
}

- (BOOL)mk_all:(BOOL (^)(id item))conditionBlock {
    return [[self allObjects] mk_all:conditionBlock];
}

- (BOOL)mk_any:(BOOL (^)(id item))conditionBlock {
    return [[self allObjects] mk_any:conditionBlock];
}

- (BOOL)mk_none:(BOOL (^)(id item))conditionBlock {
    return [[self allObjects] mk_none:conditionBlock];
}

@end
