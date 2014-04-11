//
//  NSSortDescriptor+AR.m
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

#import "NSSortDescriptor+AR.h"

#import <RubySugar/RubySugar.h>

@implementation NSSortDescriptor (AR)

+ (NSArray *)descriptors:(id)object {
    if ([object isKindOfClass:[NSArray class]]) return [self _createFromArray:object];
    if ([object isKindOfClass:[NSString class]]) return [self _descriptorsFromString:object];
    id descriptor = [self create:object];
    return (descriptor) ? @[descriptor] : nil;
}

+ (NSArray *)_createFromArray:(NSArray *)object {
    id result = [NSMutableArray array];
    for (id item in object) {
        id descriptor = [self create:item];
        if (descriptor) [result addObject:descriptor];
    }
    return result;
}

+ (NSArray *)_descriptorsFromString:(NSString *)object {
    
    id delimiter = @",";
    id objects = [object rs_split:delimiter];
    
    return [objects rs_map:^id(id item) {
        return [self _createFromString:[item rs_strip]];
    }];
}

+ (instancetype)create:(id)object {
    if ([object isKindOfClass:[self class]]) return object;
    if ([object isKindOfClass:[NSString class]]) return [self _createFromString:object];
    return nil;
}

+ (instancetype)_createFromString:(NSString *)object {
    static id descendingKey = @"!";
    if (![object rs_containsString:descendingKey]) return [self createWithKey:object ascending:YES];
    else return [self createWithKey:[object rs_delete:descendingKey] ascending:NO];
}

+ (instancetype)createWithKey:(NSString *)key ascending:(BOOL)ascending {
    return [self sortDescriptorWithKey:key ascending:ascending];
}

@end
