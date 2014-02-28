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
    
    describe(@"+from", ^{
        
    });
    
    describe(@"+createFrom", ^{
        
        __block id expected = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        
        it(@"should create from NSSortDescriptor", ^{
            id input = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            id result = [NSSortDescriptor createFrom:input];
            [[result should] beKindOfClass:[NSSortDescriptor class]];
            [[result should] equal:expected];
        });

        it(@"should create from NSString", ^{
            id input = @"name";
            id result = [NSSortDescriptor createFrom:input];
            [[result should] beKindOfClass:[NSSortDescriptor class]];
            [[result should] equal:expected];
        });
    });
    
});

SPEC_END