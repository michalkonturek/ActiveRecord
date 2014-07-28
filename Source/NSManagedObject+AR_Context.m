//
//  NSManagedObject+AR_Context.m
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

#import "NSManagedObject+AR_Context.h"

#import "NSManagedObjectContext+AR.h"

@implementation NSManagedObject (AR_Context)

+ (void)commit {
    [self commitInContext:[self managedObjectContext]];
}

+ (void)commitInContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    [context save:&error];
    if (error) [self _printError:error];
}

+ (void)rollback {
    [self rollbackInContext:[self managedObjectContext]];
}

+ (void)rollbackInContext:(NSManagedObjectContext *)context {
    [context rollback];
}

+ (NSInteger)countForRequest:(NSFetchRequest *)request {
    return [self countForRequest:request inContext:[self managedObjectContext]];
}

+ (NSInteger)countForRequest:(NSFetchRequest *)request
                   inContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSInteger result = [context countForFetchRequest:request error:&error];
    if (error) [self _printError:error];
    return result;
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request {
    return [self executeFetchRequest:request inContext:[self managedObjectContext]];
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request
                       inContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error) [self _printError:error];
    return result;
}

+ (NSManagedObjectContext *)managedObjectContext {
    return [NSManagedObjectContext managedObjectContext];
}

+ (void)_printError:(NSError *)error {
    NSLog(@"*** %@ : %@ : %@",
          [self class], NSStringFromSelector(_cmd),
          [error localizedDescription]);
    
    id detaildErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if ([detaildErrors count] > 0) {
        for (NSError *detailedError in detaildErrors) {
            NSLog(@"*** %@", [detailedError userInfo]);
        }
    } else {
        NSLog(@"*** %@", [error userInfo]);
    }
}

- (void)commit {
    [[self class] commit];
}

- (void)rollback {
    [[self class] rollback];
}

@end
