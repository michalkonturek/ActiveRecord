//
//  NSPredicate+AR_Spec.m
//  ActiveRecord
//
//  Created by Michal Konturek on 25/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "ActiveRecord.h"
#import "Domain.h"
#import "Factory.h"

SPEC_BEGIN(NSPredicate_AR_Spec)

describe(@"NSPredicate_AR", ^{
    
    describe(@"+createFrom", ^{
       
        __block id expected;
        
        beforeEach(^{
            expected = @"name == \"Adam\"";
        });
        
        it(@"should create from NSPredicate", ^{
            id input = [NSPredicate predicateWithFormat:@"name == %@", @"Adam"];
            id result = [NSPredicate createFrom:input];
            [[result should] beKindOfClass:[NSPredicate class]];
            [[[result description] should] equal:expected];
        });
        
        it(@"should create from NSString", ^{
            id input = @"name == 'Adam'";
            id result = [NSPredicate createFrom:input];
            [[result should] beKindOfClass:[NSPredicate class]];
            [[[result description] should] equal:expected];
        });
        
        it(@"should create from NSDictionary", ^{
            id input = @{@"name": @"Adam"};
            id result = [NSPredicate createFrom:input];
            [[result should] beKindOfClass:[NSPredicate class]];
            [[[result description] should] equal:expected];
        });
    });
    
    context(@"", ^{

        __block id target;
        __block id result;
        
        beforeEach(^{
            target = [NSPredicate predicateWithFormat:@"age > 10"];
        });
        
        describe(@"-and", ^{
            
            beforeEach(^{
                result = [target and:@"age != 13"];
            });
            
            it(@"should be member of NSCompoundPredicate", ^{
                [[result should] beMemberOfClass:[NSCompoundPredicate class]];
            });
            
            it(@"should create AND compound predicate", ^{
                [[[result description] should] equal:@"age > 10 AND age != 13"];
            });
        });
        
        describe(@"-or", ^{
            
            beforeEach(^{
                result = [target or:@"age != 13"];
            });
            
            it(@"should be member of NSCompoundPredicate", ^{
                [[result should] beMemberOfClass:[NSCompoundPredicate class]];
            });
            
            it(@"should create OR compound predicate", ^{
                [[[result description] should] equal:@"age > 10 OR age != 13"];
            });
        });
    });
    
});

SPEC_END
