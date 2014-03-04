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
    __block id expectedObjects;
    beforeAll(^{
        expected = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        expectedObjects = @[
                            [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:@"sex" ascending:NO]
                            ];
    });
    
    describe(@"+descriptors", ^{
        
        __block id invalid;
        __block id input;
        __block id result;
        beforeAll(^{
            invalid = [[NSObject alloc] init];
            input = @[
                      [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
                      @"age",
                      @"!sex",
                      invalid
                      ];
            result = [NSSortDescriptor descriptors:input];
        });
        
        it(@"should ignore invalid object", ^{
            [[result should] haveCountOf:3];
        });
        
        it(@"should contain only instances of NSSortDescriptor", ^{
            [result mk_each:^(id item) {
                [[item should] beKindOfClass:[NSSortDescriptor class]];
            }];
        });
        
        it(@"should contain only expected NSSortDescriptor", ^{
            [[result should] containObjectsInArray:expectedObjects];
        });
        
        it(@"should handle ", ^{
            id result = [NSSortDescriptor descriptors:@"name, age, !sex"];
            [[result should] containObjectsInArray:expectedObjects];
        });
    });
    
    describe(@"+createFrom", ^{
        
        it(@"should create from NSSortDescriptor", ^{
            id input = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            id result = [NSSortDescriptor create:input];
            [[result should] beKindOfClass:[NSSortDescriptor class]];
            [[result should] equal:expected];
        });

        it(@"should create from NSString ASC", ^{
            id input = @"name";
            id result = [NSSortDescriptor create:input];
            [[result should] beKindOfClass:[NSSortDescriptor class]];
            [[result should] equal:expected];
        });
        
        it(@"should create from NSString DESC", ^{
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
