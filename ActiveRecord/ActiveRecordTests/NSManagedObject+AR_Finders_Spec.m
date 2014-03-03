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
    
    describe(@"+hasObjects", ^{

        beforeEach(^{
            [Student deleteAll];
            [Factory createStudents:20];
        });
        
        specify(^{
            [[@([Student hasObjects]) should] equal:@(YES)];
        });
        
        specify(^{
            [Student deleteAll];
            [[@([Student hasObjects]) should] equal:@(NO)];
        });
       
        context(@"with condition", ^{
            specify(^{
                id condition = @"age < 30";
                [[@([Student hasObjects:condition]) should] equal:@(YES)];
            });
        });
    });
    
    describe(@"+count", ^{
        
        beforeAll(^{
            [Student deleteAll];
            [Factory createStudents:20];
        });
        
        it(@"should return total number of objects", ^{
            [[@([Student count]) should] equal:@20];
        });

        context(@"with condition", ^{

            it(@"should return number of objects that match condition NSString", ^{
                id condition = @"age < 30";
                [[@([Student count:condition]) should] equal:@(10)];
            });
            
            it(@"should return number of objects that match condition NSDictionary", ^{
                id condition = @{@"firstName" : @"firstName1"};
                [[@([Student count:condition]) should] equal:@(1)];
            });
            
            it(@"should return number of objects that match condition NSPredicate", ^{
                id condition = [NSPredicate predicateWithFormat:@"age < 30"];
                [[@([Student count:condition]) should] equal:@(10)];
            });
        });
    });
    
    describe(@"+object", ^{
        
        beforeAll(^{
            [Student deleteAll];
            [Factory createStudents:20];
        });
       
        context(@"with condition", ^{
            
            __block id expected;
            
            beforeEach(^{
                expected = [[Student objectWithID:@1] uid];
            });
            
            it(@"should match condition NSString", ^{
                id result = [[Student object:@"uid == 1"] uid];
                [[result should] equal:expected];
            });
            
            it(@"should match condition NSDictionary", ^{
                id result = [[Student object:@{@"uid": @1}] uid];
                [[result should] equal:expected];
            });
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
    
    describe(@"+ordered", ^{
       
        beforeAll(^{
            [Student deleteAll];
            [Factory createStudents:4];
        });
        
        context(@"ascending", ^{
            it(@"should order objects ascending", ^{
                id result = [[Student ordered:@"age"] mk_map:^id(id item) {
                    return [item age];
                }];
                [[result should] equal:@[@20, @21, @22, @23]];
            });
        });
        
        context(@"descending", ^{
            it(@"should order objects descending", ^{
                id result = [[Student ordered:@"!age"] mk_map:^id(id item) {
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
                id predicate = @"age >= 30";
                [[[Student objects:predicate] should] haveCountOf:10];
            });
            
        });
    });
    
});

SPEC_END
