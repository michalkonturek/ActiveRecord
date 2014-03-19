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
        
        context(@"when an object with specified ID already exists", ^{
            
            beforeAll(^{
                [Student deleteAll];
                [Student createWithID:uid];
            });
            
            it(@"should not create another object", ^{
                [[@([Student count]) should] equal:@1];
            });
        });
        
        context(@"when no object with specified PK exists", ^{
            
            beforeAll(^{
                [Student deleteAll];
            });

            it(@"should create new object", ^{
                [Student createOrUpdateObjectWithData:input];
                [[@([Student count]) should] equal:@1];
            });
        });
    });
    
    describe(@"+updateObject:withData", ^{

        __block id sut;
        
        beforeAll(^{
            [Student deleteAll];
            [Course deleteAll];
            sut = [Student createWithID:uid];
        });
        
        it(@"should update object's attributes", ^{
            [Student updateObject:sut withData:input];
            
            id object = [Student objectWithID:uid];
            
            [[[object uid] should] equal:[input objectForKey:@"uid"]];
            [[[object age] should] equal:[input objectForKey:@"age"]];
            [[[object firstName] should] equal:[input objectForKey:@"firstName"]];
            [[[object lastName] should] equal:[input objectForKey:@"lastName"]];
        });
        
        context(@"should update object's relationships", ^{
            
            xit(@"should handle relationship 1:1", ^{
                // add national number
            });
            
            xit(@"should handle relationship 1:m", ^{
                id course = @{@"uid": @1, @"uid": @"Software Engineering"};
                id data = @{@"uid": @1, @"course": course};
                [Student updateObject:sut withData:data];
                
                [[[[sut course] uid] should] equal:[course objectForKey:@"uid"]];
                [[[[sut course] name] should] equal:[course objectForKey:@"name"]];
            });
            
            xit(@"should handle relationship m:n", ^{
                
            });
            
            xit(@"should handle related object of [NSManagedObject class]", ^{
                
            });

            xit(@"should handle related object of [NSNumber class]", ^{
                
            });
            
            xit(@"should handle related object of [NSString class]", ^{
                
            });
            
            xit(@"should handle related object of [NSDictionary class]", ^{
                
            });
        });
    });
    
    describe(@"+", ^{
        
    });
});

SPEC_END
