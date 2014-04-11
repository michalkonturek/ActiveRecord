//
//  NSString+RubySugar.m
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
    
    if (location < [self length]) {
        id token = [[self substringFromIndex:location] rs_strip];
        [result addObject:token];
    }
    
    if ([result rs_isEmpty]) [result addObject:self];
    
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
