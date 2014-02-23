//
//  NSArray+MK_Block.h
//  MKFoundation
//
//  Created by Michal Konturek on 10/11/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MK_Block)

- (void)mk_apply:(void (^)(id item))block;

- (void)mk_each:(void (^)(id item))block;

- (instancetype)mk_map:(id (^)(id item))block;

- (id)mk_match:(BOOL (^)(id item))block;

- (id)mk_reduce:(id (^)(id item, id aggregate))block;

- (id)mk_reduce:(id)initial withBlock:(id (^)(id item, id aggregate))block;

- (instancetype)mk_reject:(BOOL (^)(id item))block;

- (instancetype)mk_select:(BOOL (^)(id item))block;

- (BOOL)mk_all:(BOOL (^)(id item))block;

- (BOOL)mk_any:(BOOL (^)(id item))block;

- (BOOL)mk_none:(BOOL (^)(id item))block;

@end
