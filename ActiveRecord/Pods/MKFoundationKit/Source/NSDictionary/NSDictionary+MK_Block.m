//
//  NSDictionary+MK_Block.m
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

#import "NSDictionary+MK_Block.h"

@implementation NSDictionary (MK_Block)

- (void)mk_apply:(void (^)(id item))block {
    if (!block) return;
    
    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
                                  usingBlock:^(id key, id obj, BOOL *stop)
    {
        block(obj);
    }];
}

- (void)mk_each:(void (^)(id item))block {
    if (!block) return;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj);
    }];
}

- (instancetype)mk_map:(id (^)(id item))selectorBlock {
    if (!selectorBlock) return [[self class] dictionary];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = selectorBlock(obj) ? : [NSNull null];
        [result setObject:value forKey:key];
    }];
    
    return result;
}

- (id)mk_match:(BOOL (^)(id key, id value))conditionBlock {
    if (!conditionBlock) return self;
    
    __block id result = nil;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (conditionBlock(key, obj)) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

- (id)mk_reduce:(id)initial withBlock:(id (^)(id item, id aggregate))accumulatorBlock {
    if (!accumulatorBlock) return self;
    
    __block id result = initial;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        result = accumulatorBlock(obj, result);
    }];
    
    return result;
}

- (instancetype)mk_reject:(BOOL (^)(id key, id value))conditionBlock {
    return [self mk_select:^BOOL(id key, id value) {
        return (!conditionBlock(key, value));
    }];
}

- (instancetype)mk_select:(BOOL (^)(id key, id value))conditionBlock {
    if (!conditionBlock) return self;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (conditionBlock(key, obj)) [result setObject:obj forKey:key];
    }];
    return result;
}

- (BOOL)mk_all:(BOOL (^)(id key, id value))conditionBlock {
    if (!conditionBlock) return YES;
    
    __block NSInteger failedCount = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!conditionBlock(key, obj)) failedCount++;
    }];
    
    return (failedCount == 0);
}

- (BOOL)mk_any:(BOOL (^)(id key, id value))conditionBlock {
    if (!conditionBlock) return NO;
    
    __block BOOL result = NO;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (conditionBlock(key, obj)) result = YES;
    }];
    
    return result;
}

- (BOOL)mk_none:(BOOL (^)(id key, id value))conditionBlock {
    return ![self mk_any:conditionBlock];
}

@end
