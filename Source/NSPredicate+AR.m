//
//  NSPredicate+AR.m
//  ActiveRecord
//
//  Copyright (c) 2014 Michal Konturek
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
