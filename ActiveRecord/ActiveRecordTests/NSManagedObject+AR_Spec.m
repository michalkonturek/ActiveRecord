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

SPEC_BEGIN(NSManagedObject_AR_Spec)

describe(@"NSManagedObject_AR", ^{

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
        
        it(@"should not commit changes", ^{
            [[[Student objects] should] haveCountOf:1];
            [Student rollback];
            [[[Student objects] should] haveCountOf:0];
        });
        
        context(@"with ID", ^{
            
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
        
        context(@"with Auto ID", ^{
            
            NSInteger count = 20;
            beforeEach(^{
                [Student deleteAll];
                [Factory createStudents:count];
            });
            
            it(@"should create with 1 if first object", ^{
                [Student deleteAll];
                id result = [Student createWithAutoID];
                [[[result uid] should] equal:@1];
            });
            
            it(@"should create with 1 if other objects have no PK", ^{
                [[Student objects] mk_each:^(id item) {
                    [item setUid:nil];
                }];
                id result = [Student createWithAutoID];
                [[[result uid] should] equal:@1];
            });
            
            it(@"should create with succ number of MAX primary key", ^{
                id expected = @(count);
                id result = [Student createWithAutoID];
                [[[result uid] should] equal:expected];
            });
            
            it(@"should create with ID > 0", ^{
                [Student deleteAll];
                [Student createWithID:@-10];
                id result = [Student createWithAutoID];
                [[[result uid] should] beGreaterThan:@0];
            });
        });
    });
    
    describe(@"-assignAutoID", ^{
        
        beforeEach(^{
            [Student deleteAll];
        });
        
        context(@"if object already has positive ID", ^{
            it(@"should not assign new ID", ^{
                id expected = @1;
                id result = [Student createWithID:expected];
                [result assignAutoID];
                [[[result uid] should] equal:expected];
            });
        });
        
        context(@"if no objects with positive ID", ^{
            it(@"should assign default ID = 1", ^{
                [Student create];
                [Student createWithID:@-1];
                
                id result = [Student create];
                [result assignAutoID];
                [[[result uid] should] equal:@1];
            });
            
            it(@"should never assign below 1", ^{
                id result = [Student createWithID:@-1];
                [result assignAutoID];
                [[[result uid] should] equal:@1];
            });
            
        });
    });
    
    describe(@"+deleteAll", ^{
        
        NSInteger count = 20;
        beforeEach(^{
            [Student deleteAll];
            [Factory createStudents:count];
        });
        
        it(@"should delete all objects", ^{
            [[[Student objects] should] haveCountOf:count];
            [Student deleteAll];
            [[[Student objects] should] haveCountOf:0];
        });
        
    });
    
    describe(@"-delete", ^{
        
        it(@"should delete specified objects", ^{
            [Student createWithID:@1];
            [Student createWithID:@2];
            [[[Student objects] should] haveCountOf:2];
            
            [[Student objectWithID:@1] delete];
            
            [[[Student objectWithID:@1] should] beNil];
            [[[Student objects] should] haveCountOf:1];
        });
    });
    
});

SPEC_END
