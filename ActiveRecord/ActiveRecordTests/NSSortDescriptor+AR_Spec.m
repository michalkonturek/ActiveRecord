//
//  NSSortDescriptor+AR_Spec.m
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
