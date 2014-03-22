//
//  ARTypeConverter_Spec.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "ActiveRecord.h"
#import "Domain.h"

#import "ARTypeConverter.h"

SPEC_BEGIN(ARTypeConverter_Spec)

describe(@"ARTypeConverter", ^{

    __block ARTypeConverter *sut;
    
    beforeEach(^{
        sut = [ARTypeConverter create];
    });
    
    describe(@"+create", ^{
        it(@"creates an instance", ^{
            [[sut shouldNot] beNil];
            [[sut should] beMemberOfClass:[ARTypeConverter class]];
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
                id expected = nil;
                [[[sut convertNSNullToNil:expected] should] beIdenticalTo:expected];
            });
        });
    });

    
});

SPEC_END





