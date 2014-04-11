//
//  ARConverter.m
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

#import "ARConverter.h"

//#import <MKFoundationKit/NSDate+MK.h>

@implementation ARConverter

//+ (instancetype)create {
//    return [[self alloc] init];
//}

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
