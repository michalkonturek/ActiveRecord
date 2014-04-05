//
//  NSPredicate+AR_Spec.m
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
