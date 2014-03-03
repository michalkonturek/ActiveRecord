//
//  NSNumber+RubySugar.m
//  RubySugar
//
//  Created by Michal Konturek on 18/12/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import "NSNumber+RubySugar.h"

@implementation NSNumber (RubySugar)

- (instancetype)rs_gcd:(NSInteger)other {
    if (other == 0) return self;
    id result = [@(other) rs_gcd:([self integerValue] % other)];
    return [self _wrap:result];
}

- (instancetype)rs_lcm:(NSInteger)other {
    if (([self integerValue] == 0) && (other == 0)) return @0;
    id result =  @(abs([self integerValue] * other) / [[self rs_gcd:other] integerValue]);
    return [self _wrap:result];
}

- (instancetype)rs_next {
    return [self _wrap:@([self integerValue] + 1)];
}

- (instancetype)rs_pred {
    return [self _wrap:@([self integerValue] - 1)];
}

- (instancetype)_wrap:(id)input {
    if ([input isMemberOfClass:[NSNumber class]]) return input;
    return [NSDecimalNumber decimalNumberWithDecimal:[input decimalValue]];
}

- (id)rs_times:(void(^)(void))block {
    if (!block) return self;
    
    NSInteger count = [self integerValue];
    for (NSInteger idx = 0; idx < count; idx++) {
        block();
    }
    
    return self;
}

- (id)rs_timesWithIndex:(void(^)(NSInteger index))block {
    if (!block) return self;
    
    NSInteger count = [self integerValue];
    for (NSInteger idx = 0; idx < count; idx++) {
        block(idx);
    }
    
    return self;
}

- (id)rs_downto:(NSInteger)limit do:(void(^)(NSInteger index))block {
    if (!block) return [[self rs_numbersTo:limit] objectEnumerator];
    if ([self integerValue] < limit) return self;
    
    for (id item in [self rs_numbersTo:limit]) {
        block([item integerValue]);
    }
    
    return self;
}

- (id)rs_upto:(NSInteger)limit do:(void(^)(NSInteger index))block {
    if (!block) return [[self rs_numbersTo:limit] objectEnumerator];
    if ([self integerValue] > limit) return self;
    
    for (id item in [self rs_numbersTo:limit]) {
        block([item integerValue]);
    }
    
    return self;
}

- (NSArray *)rs_numbersTo:(NSInteger)to {
    NSInteger from = [self integerValue];
    if (from == to) return [NSArray array];
    
    NSInteger range = labs(from - to) + 1;
    NSInteger step = (from < to) ? 1 : -1;
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:range];
    for (NSInteger i = 0; i < range; i++) {
        [result addObject:[NSNumber numberWithInteger:from]];
        from += step;
    }
    
    return result;
}

@end
