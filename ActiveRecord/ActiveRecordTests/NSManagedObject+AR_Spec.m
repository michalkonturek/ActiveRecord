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
        
        it(@"it should not commit changes", ^{
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
    
});

SPEC_END
