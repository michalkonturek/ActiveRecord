//
//  NSObject+RubySugar.m
//  RubySugar
//
//  Created by Michal Konturek on 22/08/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSObject+RubySugar.h"

@implementation NSObject (RubySugar)

- (NSArray *):(id)object {
    if (!object) return @[self];
    if ([object isKindOfClass:[NSArray class]]) return [@[self]:object];
    return @[self, object];
}

@end
