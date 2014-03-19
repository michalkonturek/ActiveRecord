//
//  NSManagedObject+AR_Serialization.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "ActiveRecord.h"
#import "Domain.h"
#import "Factory.h"

SPEC_BEGIN(NSManagedObject_AR_Serialization)

describe(@"NSManagedObject+AR_Serialization", ^{
    
    __block id uid = @100;
    __block id input = @{@"uid": uid,
                         @"age": @22,
                         @"firstName": @"Adam",
                         @"lastName": @"Smith"};
    
    describe(@"+createOrUpdateObjectWithData", ^{
        
        context(@"when object exists", ^{
            
            beforeAll(^{
                [Student deleteAll];
                [Student createWithID:uid];
            });
            
            it(@"should not create another object", ^{
                [[@([Student count]) should] equal:@1];
            });
        });
        
        context(@"when object does not exist", ^{
            
            beforeAll(^{
                [Student deleteAll];
            });

            it(@"it should create new object", ^{
                [Student createOrUpdateObjectWithData:input];
                [[@([Student count]) should] equal:@1];
            });
        });
    });
    
    describe(@"+updateObject:withData", ^{

        __block id sut;
        
        beforeAll(^{
            [Student deleteAll];
            sut = [Student createWithID:uid];
        });
        
        it(@"should update current object", ^{
            [Student updateObject:sut withData:input];
            
            id object = [Student objectWithID:uid];
            
            [[[object uid] should] equal:[input objectForKey:@"uid"]];
            [[[object age] should] equal:[input objectForKey:@"age"]];
            [[[object firstName] should] equal:[input objectForKey:@"firstName"]];
            [[[object lastName] should] equal:[input objectForKey:@"lastName"]];
        });
    });
    
    
});

SPEC_END
