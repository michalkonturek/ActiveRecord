//
//  NSManagedObject+AR_Finders_Spec.m
//  ActiveRecord
//
//  Created by Michal Konturek on 23/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "ActiveRecord.h"
#import "Domain.h"
#import "Factory.h"

#import <MKFoundationKit/NSArray+MK_Block.h>

SPEC_BEGIN(NSManagedObject_AR_Finders_Spec)

describe(@"NSManagedObject_AR_Finders", ^{
    
    describe(@"+count", ^{
        
        beforeAll(^{
            [Student deleteAll];
            [Factory createStudents:20];
        });
        
        it(@"should return total number of objects", ^{
            [[@([Student count]) should] equal:@20];
        });
        
        context(@"with Predicate", ^{
            it(@"should return number of objects that satisfy predicate", ^{
                id predicate = [NSPredicate predicateWithFormat:@"age < 30"];
                [[@([Student countWithPredicate:predicate]) should] equal:@(10)];
            });
        });
    });
    
    describe(@"+object", ^{
        
        beforeAll(^{
            [Student deleteAll];
            [Factory createStudents:20];
        });
       
        context(@"with ID", ^{
            it(@"should read only a specified object", ^{
                id target = [Student objectWithID:@1];
                [[[target uid] should] equal:@1];
                [[[target firstName] should] equal:@"firstName1"];
                [[[target lastName] should] equal:@"lastName1"];
                [[[target age] should] equal:@21];
            });
        });
        
        context(@"with predicate", ^{
            it(@"should returns object with surname 'lastName10'", ^{
                id predicate = [NSPredicate createFrom:@"lastName == 'lastName10'"];
                id target = [Student objectWithPredicate:predicate];
                [[[target lastName] should] equal:@"lastName10"];
            });
        });

        context(@"with max value for attribute", ^{
            it(@"should return object with age 39", ^{
                id target = [Student objectWithMaxValueFor:@"age"];
                [[[target age] should] equal:@39];
            });
        });
        
        context(@"with min value for attribute", ^{
            it(@"should return object with age 20", ^{
                id target = [Student objectWithMinValueFor:@"age"];
                [[[target age] should] equal:@20];
            });
        });
    });
    
    describe(@"+orderedBy", ^{
       
        beforeAll(^{
            [Student deleteAll];
            [Factory createStudents:4];
        });
        
        context(@"ascending", ^{
            it(@"orders objects by single property ascending", ^{
                id result = [[Student orderedAscendingBy:@"age"] mk_map:^id(id item) {
                    return [item age];
                }];
                [[result should] equal:@[@20, @21, @22, @23]];
            });
        });
        
        context(@"descending", ^{
            it(@"orders objects by single property descending", ^{
                id result = [[Student orderedDescendingBy:@"age"] mk_map:^id(id item) {
                    return [item age];
                }];
                [[result should] equal:@[@23, @22, @21, @20]];
            });
        });
    });
    
    describe(@"+objects", ^{
        
        NSInteger count = 20;
        
        beforeEach(^{
            [Student deleteAll];
            [Factory createStudents:count];
        });

        it(@"should return ALL objects", ^{
            [[[Student objects] should] haveCountOf:count];
        });

        context(@"with predicate", ^{
            it(@"should read only objects that match predicate", ^{
                id predicate = [NSPredicate predicateWithFormat:@"age >= 30"];
                [[[Student objectsWithPredicate:predicate] should] haveCountOf:10];
            });
            
        });
    });
    
});

SPEC_END
