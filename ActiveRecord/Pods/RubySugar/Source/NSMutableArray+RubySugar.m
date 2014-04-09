//
//  NSMutableArray+RubySugar.m
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
