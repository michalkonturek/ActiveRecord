//
//  NSManagedObject+NSFetchRequest.m
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

#import "NSManagedObject+AR_Request.h"

#import "NSFetchRequest+AR.h"
#import "NSManagedObject+AR.h"

@implementation NSManagedObject (AR_Request)

+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate
                      withSortDescriptor:(NSSortDescriptor *)descriptor {
    id descriptors = (descriptor != nil) ? @[descriptor] : nil;
    return [self requestWithPredicate:predicate withSortDescriptors:descriptors];
}

+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate
                     withSortDescriptors:(NSArray *)descriptors {
    
    id request = [NSFetchRequest createWithPredicate:predicate withSortDescriptors:descriptors];
    [request setEntity:[self entityDescription]];
    return request;
}

@end
