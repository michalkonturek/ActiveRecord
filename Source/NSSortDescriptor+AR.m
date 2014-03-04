//
//  NSSortDescriptor+AR.m
//  ActiveRecord
//
//  Created by Michal Konturek on 25/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSSortDescriptor+AR.h"

#import <RubySugar/RubySugar.h>
//#import <MKFoundationKit/NSArray+MK_Block.h>

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
    // NOTE: there is a bug in rs_splut => returns empty array if no pattern matches
    // There is another bug => does not take the last component.
    
    id delimiter = @",";
    
    id objects = nil;
    if ([object rs_containsString:delimiter]) {
        objects = [[object componentsSeparatedByString:delimiter]
                   rs_map:^id(id item) {
                       return [item rs_strip];
                   }];
    } else {
        objects = @[object];
    }
    
    return [objects rs_map:^id(id item) {
        return [self _createFromString:item];
    }];
}

+ (instancetype)create:(id)object {
    if ([object isKindOfClass:[self class]]) return object;
//    if ([object isKindOfClass:[NSString class]]) return [self createWithKey:object ascending:YES];
    if ([object isKindOfClass:[NSString class]]) return [self _createFromString:object];
    return nil;
}

+ (instancetype)_createFromString:(NSString *)object {
    static id key = @"!";
    if (![object rs_containsString:key]) return [self createWithKey:object ascending:YES];
    else return [self createWithKey:[object rs_delete:key] ascending:NO];

    //    static id keyMulti = @",";
//    
//    if ([object rs_containsString:keyMulti]) {
//        id objects = [[object rs_split:keyMulti] mk_map:^id(id item) {
//            return [item rs_strip];
//        }];
//        return [self descriptors:objects];
//    } else {
//        if (![object rs_containsString:key]) return [self createWithKey:object ascending:YES];
//        else return [self createWithKey:[object rs_delete:key] ascending:NO];
//    }
}

+ (instancetype)createWithKey:(NSString *)key ascending:(BOOL)ascending {
    return [self sortDescriptorWithKey:key ascending:ascending];
}

@end
