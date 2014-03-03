//
//  NSSortDescriptor+AR_Spec.m
//  ActiveRecord
//
//  Created by Michal Konturek on 25/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "ActiveRecord.h"
#import "Domain.h"
#import "Factory.h"

SPEC_BEGIN(NSSortDescriptor_AR_Spec)

describe(@"NSSortDescriptor_AR", ^{
    
    __block id expected;
    beforeAll(^{
        expected = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    });
    
    describe(@"+from", ^{
        __block id invalid;
        __block id input;
        __block id result;
        beforeAll(^{
            invalid = [[NSObject alloc] init];
            input = @[
                      [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
                      @"name",
                      invalid];
            result = [NSSortDescriptor descriptors:input];
        });
        
        it(@"should ignore invalid object", ^{
            [[result should] haveCountOf:2];
        });
        
        it(@"should contain only instances of NSSortDescriptors", ^{
            [result mk_each:^(id item) {
                [[item should] beKindOfClass:[NSSortDescriptor class]];
            }];
        });
        
        it(@"should contain only expected NSSortDescriptors", ^{
            [result mk_each:^(id item) {
                [[item should] equal:expected];
            }];
        });
    });
    
    describe(@"+createFrom", ^{
        
        it(@"should create from NSSortDescriptor", ^{
            id input = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            id result = [NSSortDescriptor create:input];
            [[result should] beKindOfClass:[NSSortDescriptor class]];
            [[result should] equal:expected];
        });

        it(@"should create from NSString ascending", ^{
            id input = @"name";
            id result = [NSSortDescriptor create:input];
            [[result should] beKindOfClass:[NSSortDescriptor class]];
            [[result should] equal:expected];
        });
        
        it(@"should create from NSString descending", ^{
            id expected = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
            id input = @"!name";
            id result = [NSSortDescriptor create:input];
            [[result should] beKindOfClass:[NSSortDescriptor class]];
            [[result should] equal:expected];
        });
    });
    
    describe(@"+createWithKey", ^{
        
        it(@"creates NSSortDescriptor with right key ASC", ^{
            id result = [NSSortDescriptor createWithKey:@"name" ascending:YES];
            [[result should] equal:expected];
        });
        
        it(@"creates NSSortDescriptor with right key DESC", ^{
            id expected = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
            id result = [NSSortDescriptor createWithKey:@"name" ascending:NO];
            [[result should] equal:expected];
        });
    });
});

SPEC_END
