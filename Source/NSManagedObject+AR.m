//
//  NSManagedObject+ActiveRecord.m
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

#import "NSManagedObject+AR.h"

#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_Finders.h"

#import <MKFoundationKit/NSArray+MK_Block.h>
#import <MKFoundationKit/NSNumber+MK.h>

@implementation NSManagedObject (AR)

+ (instancetype)createWithAutoID {
    id object = [self create];
    [object assignAutoID];
    return object;
}

- (void)assignAutoID {
    id key = [[self class] primaryKey];
    id pk = [self _autoGenerateID];
    [self setValue:pk forKey:key];
}

- (NSNumber *)_autoGenerateID {
    id defaultID = @1;
    id key = [[self class] primaryKey];
    
    id pk = [self valueForKey:key];
    if ([pk integerValue] > 0) return pk;
    
    id object = [[self class] objectWithMaxValueFor:key];
    if (object) {
        id max = [object valueForKey:key];
        
        if (!max) return defaultID;
        if (!([max integerValue] > 0)) return defaultID;
        
        return @([max integerValue] + 1);
    }
    
    return defaultID;
}

+ (instancetype)createWithID:(NSNumber *)objectID {
    id object = [self objectWithID:objectID];
    if (!object) object = [self create];
    [object setValue:objectID forKey:[self primaryKey]];
    return object;
}

+ (instancetype)create {
    id context = [self managedObjectContext];
    id entityName = [self entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:context];
}

+ (NSEntityDescription *)entityDescription {
    id entityName = [self entityName];
    id context = [self managedObjectContext];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
}

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (NSString *)primaryKey {
    return @"uid";
}

+ (void)deleteAll {
    [[self objects] mk_each:^(id item) {
        [item delete];
    }];
}

- (void)delete {
    [self.managedObjectContext deleteObject:self];
}

- (BOOL)isTheSame:(id)other {
    if (![self isMemberOfClass:[other class]]) return NO;
    id pk = [[self class] primaryKey];
    return [[self valueForKeyPath:pk] mk_isTheSame:[other valueForKeyPath:pk]];
}

@end
