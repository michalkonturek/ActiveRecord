//
//  KiwiExample.m
//  ActiveRecord
//
//  Created by Michal Konturek on 18/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi.h>

SPEC_BEGIN(Example)

describe(@"Example test for Kiwi", ^{
    
    it(@"One should be one", ^{
        [[@1 should] equal:@1];
    });
    
});

SPEC_END
