//
//  NSMutableArray+RubySugar.h
//  RubySugar
//
//  Created by Michal Konturek on 26/12/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+RubySugar.h"

@interface NSMutableArray (RubySugar)

/**
 Removes all elements from self and returns self.
 */
- (instancetype)rs_clear;

/**
 Removes all items that are equal to object and returns self.
 */
- (instancetype)rs_delete:(id)object;

/**
 Removes object at index and returns self.
 If index is negative, removes from back.
 */
- (instancetype)rs_deleteAt:(NSInteger)index;

/**
 Removes all elements for which block evaluates true.
 Returns self if block is specified, otherwise it returns enumerator.
 */
- (id)rs_deleteIf:(BOOL(^)(id item))block;

@end
