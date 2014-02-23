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

describe(@"NSManagedObject+AR", ^{

    
    describe(@"+create", ^{
        
        __block Student *sut;
        
        beforeEach(^{
            [Student deleteAll];
            [Student commit];
            sut = [Student create];
        });

        specify(^{
            [[sut shouldNot] beNil];
        });
        
        specify(^{
            [[sut should] beMemberOfClass:[Student class]];
        });
        
        it(@"it should not commit changes", ^{
            [[[Student objects] should] haveCountOf:1];
            [Student rollback];
            [[[Student objects] should] haveCountOf:0];
        });
        
        context(@"withID", ^{
            
            __block NSNumber *uid = @1;
            
            beforeEach(^{
                [Student deleteAll];
                sut = [Student createWithID:uid];
            });
            
            it(@"should has ID", ^{
                [[sut.uid should] equal:uid];
            });
            
            it(@"should not create duplicate object with the same ID", ^{
                id other = [Student createWithID:uid];
                [[other should] equal:sut];
            });
        });
    });
    
    describe(@"+deleteAll", ^{
        
        NSInteger count = 20;
        
        beforeEach(^{
            [Student deleteAll];
            [Factory createStudents:count];
        });
        
        it(@"it should delete all objects", ^{
            [[[Student objects] should] haveCountOf:count];
            [Student deleteAll];
            [[[Student objects] should] haveCountOf:0];
        });
        
    });
    
    describe(@"-delete", ^{
        
        it(@"it should delete specified objects", ^{
            [Student createWithID:@1];
            [Student createWithID:@2];
            [[[Student objects] should] haveCountOf:2];
            
            [[Student objectWithID:@1] delete];
            
            [[[Student objectWithID:@1] should] beNil];
            [[[Student objects] should] haveCountOf:1];
        });
    });
    

    
    
    
//    NSInteger count = 20;
//    
//    beforeEach(^{
//        [Student deleteAll];
//    });
//
//    context(@"Create", ^{
//        
//        it(@"should create object", ^{
//            Student *student = [Student createWithID:@100];
//            student.firstName = @"John";
//            student.lastName = @"Doe";
//            student.age = @21;
//            
//            id result = [Student objects][0];
//            [[result should] beMemberOfClass:[Student class]];
//            [[[result firstName] should] equal:@"John"];
//            [[[result lastName] should] equal:@"Doe"];
//            [[[result age] should] equal:theValue(21)];
//        });
//    });
//    
//    context(@"Read", ^{
//        
//        beforeEach(^{
//            [Factory createStudents:count];
//        });
//        
//        it(@"should read ALL objects", ^{
//            [[[Student objects] should] haveCountOf:count];
//        });
//        
//        it(@"should read only objects that match predicate", ^{
//            id predicate = [NSPredicate predicateWithFormat:@"age >= 30"];
//            [[[Student objectsWithPredicate:predicate] should] haveCountOf:10];
//        });
//        
//        it(@"should read only a specified object", ^{
//            id item = [Student objectWithID:@1];
//            [[[item uid] should] equal:@1];
//            [[[item firstName] should] equal:@"firstName1"];
//            [[[item lastName] should] equal:@"lastName1"];
//            [[[item age] should] equal:@21];
//        });
//        
//        it(@"should return only ", ^{
//            
//        });
//    });
//    
////    context(@"Update", ^{
////       
////        it(@"", ^{
////            
////        });
////    });
//    
//    context(@"Delete", ^{
//        
//        beforeEach(^{
//            [Factory createStudents:count];
//        });
//        
//        it(@"it should delete all objects", ^{
//            [[[Student objects] should] haveCountOf:count];
//            [Student deleteAll];
//            [[[Student objects] should] haveCountOf:0];
//        });
//        
//        it(@"it should delete specific object", ^{
//            [[[Student objects] should] haveCountOf:count];
//
//            [[Student objectWithID:@1] delete];
//
//            [[[Student objectWithID:@1] should] beNil];
//            [[[Student objects] should] haveCountOf:(count - 1)];
//        });
//    });
    
});

SPEC_END
