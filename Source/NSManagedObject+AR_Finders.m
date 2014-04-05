//
//  NSManagedObject+AR_Finders.m
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

#import "NSManagedObject+AR_Finders.h"

#import "NSManagedObject+AR.h"
#import "NSManagedObject+AR_Context.h"
#import "NSManagedObject+AR_Request.h"

#import "NSSortDescriptor+AR.h"
#import "NSPredicate+AR.h"

@implementation NSManagedObject (AR_Finders)

+ (BOOL)hasObjects {
    return [self hasObjectsWithPredicate:nil];
}

+ (BOOL)hasObjects:(id)condition {
    return [self hasObjectsWithPredicate:[NSPredicate createFrom:condition]];
}

+ (BOOL)hasObjectsWithPredicate:(NSPredicate *)predicate {
    return ([self countWithPredicate:predicate] != 0);
}

+ (NSInteger)count {
    return [self countWithPredicate:nil];
}

+ (NSInteger)count:(id)condition {
    return [self countWithPredicate:[NSPredicate createFrom:condition]];
}

+ (NSInteger)countWithPredicate:(NSPredicate *)predicate {
    id request = [self requestWithPredicate:predicate withSortDescriptor:nil];
    return [self countForRequest:request];
}

+ (instancetype)object:(id)condition {
    return [self objectWithPredicate:[NSPredicate createFrom:condition]];
}

+ (instancetype)objectWithID:(NSNumber *)objectID {
    id predicate = [NSPredicate predicateWithFormat:@"%K == %@", [self primaryKey], objectID];
    return [self objectWithPredicate:predicate];
}

+ (instancetype)objectWithPredicate:(NSPredicate *)predicate {
    return [self firstWithPredicate:predicate];
}

+ (instancetype)objectWithMaxValueFor:(NSString *)attribute {
    id predicate = [NSPredicate predicateWithFormat:@"%K != nil", attribute];
    id descriptor = [NSSortDescriptor sortDescriptorWithKey:attribute ascending:NO];
    return [self firstWithPredicate:predicate withSortDescriptor:descriptor];
}

+ (instancetype)objectWithMinValueFor:(NSString *)attribute {
    id predicate = [NSPredicate predicateWithFormat:@"%K != nil", attribute];
    id descriptor = [NSSortDescriptor sortDescriptorWithKey:attribute ascending:YES];
    return [self firstWithPredicate:predicate withSortDescriptor:descriptor];
}

+ (instancetype)firstWithPredicate:(NSPredicate *)predicate {
    return [self firstWithPredicate:predicate withSortDescriptor:nil];
}

+ (instancetype)firstWithPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)descriptor {
    id result = [self objectsWithPredicate:predicate withSortDescriptor:descriptor];
    if ([result count] > 0) return [result objectAtIndex:0];
    else return nil;
}

+ (NSArray *)orderedAscendingBy:(NSString *)key {
    return [self ordered:key];
}

+ (NSArray *)orderedDescendingBy:(NSString *)key {
    return [self ordered:[NSSortDescriptor createWithKey:key ascending:NO]];
}

+ (NSArray *)ordered:(id)order {
    return [self objects:nil ordered:order];
}

+ (NSArray *)objects {
    return [self objects:nil];
}

+ (NSArray *)objects:(id)condition {
    return [self objects:condition ordered:nil];
}

+ (NSArray *)objects:(id)condition ordered:(id)order {
    id predicate = [NSPredicate createFrom:condition];
    id descriptor = [NSSortDescriptor descriptors:order];
    return [self objectsWithPredicate:predicate
                  withSortDescriptors:descriptor];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate {
    return [self objectsWithPredicate:predicate withSortDescriptors:nil];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate
               withSortDescriptor:(NSSortDescriptor *)descriptor {
    id descriptors = (descriptor) ? @[descriptor] : nil;
    return [self objectsWithPredicate:predicate withSortDescriptors:descriptors];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate
              withSortDescriptors:(NSArray *)descriptors {
    id request = [self requestWithPredicate:predicate withSortDescriptors:descriptors];
    return [self executeFetchRequest:request];
}

@end
