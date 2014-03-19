//
//  ARTypeConverter.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "ARTypeConverter.h"

//#import <MKFoundationKit/NSDate+MK.h>

/*
 
 This class was used only when incorrect JSON was passed, 
 i.e. numbers were decoded as strings.
 
 Converter could be included as a module in case somebody wants to pass it.
 
 */

@implementation ARTypeConverter

+ (id)convertValue:(id)value toDataType:(NSAttributeType)type {
    
    if ([value isKindOfClass:[NSString class]]) {
        return [[self class] convertString:value toDataType:type];
    } else {
        return value;
    }
    
//    if ([value isKindOfClass:[NSNumber class]]) {
//        return value;
//    }
    
    return nil;
}

+ (id)convertString:(NSString *)value toDataType:(NSAttributeType)type {
    
    switch (type) {
        case NSStringAttributeType:
            return value;
            break;
        case NSInteger16AttributeType:
            return [[self class] convertNSStringToNSNumber:value];
            break;
        case NSInteger32AttributeType:
            return [[self class] convertNSStringToNSNumber:value];
            break;
        case NSInteger64AttributeType:
            return [[self class] convertNSStringToNSNumberLong:value];
            break;
        case NSBooleanAttributeType:
            return [[self class] convertNSStringToNSNumberBool:value];
            break;
//        case NSDateAttributeType:
//            return [NSDate mk_dateFromString:value];
//            break;
        default:
            return nil;
            break;
    }
}

+ (NSNumber *)convertNSStringToNSNumberOrNSNull:(NSString *)value {
    return [self convertNilToNSNull:[self convertNSStringToNSNumber:value]];
}

+ (NSNumber *)convertNSStringToNSNumber:(NSString *)value {
    
    if ((NSNull *)value != [NSNull null] && value != nil) {
        @try {
            return [NSNumber numberWithInteger:[value integerValue]];
        }
        @catch (NSException *exception) {
            return nil;
        }
    }
    
    return nil;
}

+ (NSNumber *)convertNSStringToNSNumberLongOrNSNull:(NSString *)value {
    return [self convertNilToNSNull:[self convertNSStringToNSNumberLong:value]];
}

+ (NSNumber *)convertNSStringToNSNumberLong:(NSString *)value {
    
    if ((NSNull *)value != [NSNull null] && value != nil) {
        @try {
            return [NSNumber numberWithLongLong:[value longLongValue]];
        }
        @catch (NSException *exception) {
            return nil;
        }
    }
    
    return nil;
}

+ (NSNumber *)convertNSStringToNSNumberBool:(NSString *)value {
    return [NSNumber numberWithBool:[self convertNSStringToBool:value]];
}

+ (BOOL)convertNSStringToBool:(NSString *)value {
    
    if ((NSNull *)value != [NSNull null] && value != nil) {
        @try {
            if ([value isEqualToString:@"Y"] == YES || [value isEqualToString:@"y"] == YES) {
                return YES;
            }
        }
        @catch (NSException *exception) {
            return NO;
        }
    }
    
    return NO;
}

+ (id)convertNilToNSNull:(id)value {
    return (value == nil) ? [NSNull null] : value;
}

+ (id)convertNSNullToNil:(id)value {
    return ((NSNull *)value == [NSNull null]) ? nil : value;
}


@end
