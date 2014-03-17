//
//  NSString+RubySugar.m
//  RubySugar
//
//  Created by Michal Konturek on 12/12/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import "NSString+RubySugar.h"

@implementation NSString (RubySugar)

- (NSString *):(id)object {
    if (!object) return self;
    
    id result = [NSMutableString stringWithString:self];
    id string = [self _stringValueOf:object];
    [result appendString:string];
    
    return result;
}

- (NSString *)_stringValueOf:(id)object {
    if ([object isKindOfClass:[NSString class]]) return object;
    else if ([object respondsToSelector:@selector(description)]) return [object description];
    else return @"";
}

- (NSString *):(NSInteger)from :(NSInteger)to {
    return [self :from :to exclusive:NO];
}

- (NSString *):(NSInteger)from :(NSInteger)to exclusive:(BOOL)exclusive {
    id op = (exclusive) ? @"..." : @"..";
    return self[[NSString stringWithFormat:@"%li%@%li", (long)from, op, (long)to]];
}

- (NSArray *)rs_chars {
    return [self rs_split:@""];
}

- (BOOL)rs_containsString:(NSString *)term {
    return [self rs_containsString:term caseSensitive:YES];
}

- (BOOL)rs_containsString:(NSString *)term caseSensitive:(BOOL)caseSensitive {
    NSString *target = (caseSensitive) ? self : [self lowercaseString];
    NSString *searchTerm = (caseSensitive) ? term : [term lowercaseString];
    NSRange range = [target rangeOfString:searchTerm];
    return (range.location != NSNotFound);
}

- (NSString *)rs_delete:(id)input {
    
    if ([input isKindOfClass:[NSString class]]) {
        return [self stringByReplacingOccurrencesOfString:input withString:@""];
    }
    
    if ([input conformsToProtocol:@protocol(NSFastEnumeration)]) {
        if ([input isKindOfClass:[NSDictionary class]]) input = [input allObjects];
        
        id result = [self copy];
        for (id term in input) {
            result = [result stringByReplacingOccurrencesOfString:term withString:@""];
        }
        return result;
    }
    
    return self;
}

- (id)rs_eachChar:(void (^)(NSString *))block {
    if (!block) return [[self rs_chars] objectEnumerator];
    
    for (id item in [self rs_chars]) {
        block(item);
    }
    
    return self;
}

- (BOOL)rs_isEmpty {
    return (self.length == 0);
}

- (NSString *)rs_justifyLeft:(NSInteger)length {
    return [self rs_justifyLeft:length with:@" "];
}

- (NSString *)rs_justifyLeft:(NSInteger)length with:(NSString *)pad {
    if (length <= [self length]) return self;
    
    id result = [NSMutableString stringWithString:self];
    
    length -= [self length];
    for (NSInteger idx = 0; idx < length; idx++) {
        [result appendString:pad];
    }
    
    return result;
}

- (NSString *)rs_justifyRight:(NSInteger)length {
    return [self rs_justifyRight:length with:@" "];
}

- (NSString *)rs_justifyRight:(NSInteger)length with:(NSString *)pad {
    if (length <= [self length]) return self;
    
    id result = [NSMutableString string];
    
    length -= [self length];
    for (NSInteger idx = 0; idx < length; idx++) {
        [result appendString:pad];
    }
    
    [result appendString:self];
    
    return result;
}

- (NSArray *)rs_split {
    return [self rs_split:nil];
}

- (NSArray *)rs_split:(NSString *)pattern {
    if (!pattern) {
        return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    if ([pattern rs_isEmpty]) pattern = @"s*";
    
    NSError *error = nil;
    NSRegularExpression *rx = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                        options:0
                                                                          error:&error];
    
    NSInteger location = 0;
    id result = [NSMutableArray array];
    id matches = [rx matchesInString:self options:0 range:[self rangeOfString:self]];
    for (NSTextCheckingResult *match in matches) {
        NSRange range = NSMakeRange(location, (match.range.location - location));
        id token = [self substringWithRange:range];
        if (![token rs_isEmpty]) [result addObject:token];
        location = match.range.location + match.range.length;
    }
    
    return result;
}

- (NSString *)rs_strip {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    if (index >= [self length]) return nil;
    unichar character = [self characterAtIndex:index];
    return [NSString stringWithCharacters:&character length:1];
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
    static NSString *inclusiveRange = @"..";
    static NSString *exclusiveRange = @"...";
    
    if ([(id)key isKindOfClass:[NSString class]]) {
        
        NSRange range = NSRangeFromString((NSString *)key);
        if ([(NSString *)key rs_containsString:exclusiveRange]) {
            range = NSMakeRange(range.location + 1, range.length - range.location - 1);
        } else if ([(NSString *)key rs_containsString:inclusiveRange]) {
            range = NSMakeRange(range.location, range.length - range.location + 1);
        }
        
        return [self substringWithRange:range];
    } if ([(id)key isKindOfClass:[NSValue class]]) {
        
        NSRange range = [(NSValue *)key rangeValue];
        range.length = 1;
        return [self substringWithRange:range];

    } else @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}

@end
