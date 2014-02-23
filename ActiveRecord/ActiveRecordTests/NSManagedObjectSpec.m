//
//  NSManagedObjectSpec.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "ActiveRecord.h"
#import "Domain.h"
#import "Factory.h"

SPEC_BEGIN(NSManagedObjectSpec)

describe(@"NSManagedObjectSpec", ^{
    
    NSInteger count = 20;
    
    beforeEach(^{
        [Student deleteAll];
    });

    context(@"Create", ^{
        
        it(@"should create object", ^{
            Student *student = [Student create];
            student.uid = @1;
            student.firstName = @"John";
            student.lastName = @"Doe";
            student.age = @21;
            
            id result = [Student objects][0];
            [[result should] beMemberOfClass:[Student class]];
            [[[result firstName] should] equal:@"John"];
            [[[result lastName] should] equal:@"Doe"];
            [[[result age] should] equal:theValue(21)];
        });
    });
    
    context(@"Read", ^{
        
        beforeEach(^{
            [Factory createStudents:count];
        });
        
        it(@"should read ALL objects", ^{
            [[[Student objects] should] haveCountOf:count];
        });
        
        it(@"should read only objects that match predicate", ^{
            id predicate = [NSPredicate predicateWithFormat:@"age >= 30"];
            [[[Student objectsWithPredicate:predicate] should] haveCountOf:10];
        });
        
//        it(@"should read specific object", ^{
//            [[[Student objects] should] haveCountOf:count];
//        });
    });
    
//    context(@"Update", ^{
//       
//        it(@"", ^{
//            
//        });
//    });
    
    context(@"Delete", ^{
        
        beforeEach(^{
            [Factory createStudents:count];
        });
        
        it(@"it should delete all objects", ^{
            [[[Student objects] should] haveCountOf:count];
            [Student deleteAll];
            [[[Student objects] should] haveCountOf:0];
        });
        
        it(@"it should delete specific object", ^{
            [[[Student objects] should] haveCountOf:count];

            [[Student objectWithID:@1] delete];

            [[[Student objectWithID:@1] should] beNil];
            [[[Student objects] should] haveCountOf:(count - 1)];
        });
    });
    
});

SPEC_END
