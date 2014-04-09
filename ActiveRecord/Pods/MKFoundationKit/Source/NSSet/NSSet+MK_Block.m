//
//  NSSet+MK_Block.m
//  MKFoundation
//
//  Copyright (c) 2013 Michal Konturek
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
