//
//  NSNumber+RubySugar.h
//  RubySugar
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

#import <Foundation/Foundation.h>

@interface NSNumber (RubySugar)

/**
 Returns the greatest common divisor (always positive).
 */
- (instancetype)rs_gcd:(NSInteger)other;

/**
 Returns the least common multiple (always positive).
 */
- (instancetype)rs_lcm:(NSInteger)other;

/**
 Returns successor integer, i.e. i + 1.
 */
- (instancetype)rs_next;

/**
 Returns predecessor integer, i.e. i - 1.
 */
- (instancetype)rs_pred;

/**
 Iterates block n times, passing in values from zero to (n - 1).
 Returns self. If no block is given, an enumerator is returned instead.
 */
- (id)rs_times:(void(^)(void))block;

/**
 Iterates block n times, passing in values from zero to (n - 1).
 Returns self. If no block is given, an enumerator is returned instead.
 */
- (id)rs_timesWithIndex:(void(^)(NSInteger index))block;

/**
 Iterates block, passing decreasing values from integer down to and including limit.
 Returns self. If no block is given, an enumerator is returned instead.
 */
- (id)rs_downto:(NSInteger)limit do:(void(^)(NSInteger index))block;

/**
 Iterates block, passing in integer values from integer up to and including limit.
 Returns self. If no block is given, an enumerator is returned instead.
 */
- (id)rs_upto:(NSInteger)limit do:(void(^)(NSInteger index))block;

/**
 Creates array with integers between from and to inclusively.
 */
- (NSArray *)rs_numbersTo:(NSInteger)to;

@end
