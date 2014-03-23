//
//  ARConverter.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "ARConverter.h"

//#import <MKFoundationKit/NSDate+MK.h>

@implementation ARConverter

+ (instancetype)create {
    return [[self alloc] init];
}

- (id)convert:(id)value toAttributeType:(NSAttributeType)type {
    if (![value isKindOfClass:[NSString class]]) return value;
    return [self convertString:value toAttributeType:type];
}

- (id)convertString:(NSString *)value toAttributeType:(NSAttributeType)type {
    switch (type) {
        case NSStringAttributeType:
            return value;
            break;
        case NSInteger16AttributeType:
            return [self convertNSStringToNSNumber:value];
            break;
        case NSInteger32AttributeType:
            return [self convertNSStringToNSNumber:value];
            break;
        case NSInteger64AttributeType:
            return [self convertNSStringToNSNumber:value];
            break;
//        case NSDateAttributeType:
//            return [NSDate mk_dateFromString:value];
//            break;
        default:
            return nil;
            break;
    }
}

- (NSNumber *)convertNSStringToNSNumber:(NSString *)value {
    if (!value) return nil;
    if ([[NSNull null] isEqual:value]) return nil;
    
    @try {
        return @([value longLongValue]);
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (id)convertNilToNSNull:(id)value {
    if (!value) return [NSNull null];
    return value;
}

- (id)convertNSNullToNil:(id)value {
    if ([[NSNull null] isEqual:value]) return nil;
    return value;
}

@end
