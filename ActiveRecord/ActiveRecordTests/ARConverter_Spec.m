//
//  ARConverter_Spec.m
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

#import "ARConverter.h"

SPEC_BEGIN(ARConverter_Spec)

describe(@"ARConverter", ^{

    __block ARConverter *sut;
    
    beforeEach(^{
        sut = [ARConverter create];
    });
    
    describe(@"+create", ^{
        it(@"creates an instance", ^{
            [[sut shouldNot] beNil];
            [[sut should] beMemberOfClass:[ARConverter class]];
        });
    });
    
    describe(@"-convert:toAttributeType:", ^{
        
        context(@"when type is not supported", ^{
            it(@"returns same instance", ^{
                id expected = @1;
                [[[sut convert:expected toAttributeType:NSStringAttributeType] should] beIdenticalTo:expected];
            });
        });
    });
    
    describe(@"-convertString:toAttributeType:", ^{
        
        it(@"returns input when NSString type", ^{
            id expected = @"Some data";
            id result = [sut convertString:expected toAttributeType:NSStringAttributeType];
            [[result should] equal:expected];
            [[result should] beIdenticalTo:expected];
        });
        
        it(@"converts to NSInteger16", ^{
            id expected = @(NSIntegerMax);
            id input = [expected stringValue];
            id result = [sut convertString:input toAttributeType:NSInteger16AttributeType];
            [[result should] equal:expected];
        });
        
        it(@"converts to NSInteger32", ^{
            id expected = @(NSIntegerMax);
            id input = [expected stringValue];
            id result = [sut convertString:input toAttributeType:NSInteger32AttributeType];
            [[result should] equal:expected];
        });
        
        it(@"converts to NSInteger64", ^{
            id expected = @(LONG_LONG_MAX);
            id input = [expected stringValue];
            id result = [sut convertString:input toAttributeType:NSInteger64AttributeType];
            [[result should] equal:expected];
        });
        
        it(@"converts to NSNumber bool", ^{
            
        });
    });
    
    describe(@"convertNilToNSNull", ^{
       
        context(@"when nil", ^{
            it(@"returns NSNull", ^{
                id expected = [NSNull null];
                [[[sut convertNilToNSNull:nil] should] equal:expected];
            });
        });
        
        context(@"when not nil", ^{
            it(@"returns same instance", ^{
                id expected = [NSNull null];
                [[[sut convertNilToNSNull:expected] should] beIdenticalTo:expected];
            });
        });
    });

    describe(@"convertNSNullToNil", ^{
        
        context(@"when NSNull", ^{
            it(@"returns nill", ^{
                [[[sut convertNSNullToNil:[NSNull null]] should] beNil];
            });
        });
        
        context(@"when not NSNull", ^{
            it(@"returns same instance", ^{
                id expected = @1;
                [[[sut convertNSNullToNil:expected] should] beIdenticalTo:expected];
            });
        });
    });

    
});

SPEC_END
