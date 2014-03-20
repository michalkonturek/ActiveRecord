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
        
        beforeEach(^{
            [Student deleteAll];
        });
        
        context(@"when an object with specified ID already exists", ^{
            
            beforeAll(^{
                [Student createWithID:uid];
            });
            
            it(@"should not create another object", ^{
                [[@([Student count]) should] equal:@1];
            });
        });
        
        context(@"when no object with specified PK exists", ^{
            it(@"should create new object", ^{
                [Student createOrUpdateObjectWithData:input];
                [[@([Student count]) should] equal:@1];
            });
        });
    });
    
    describe(@"+updateObject:withData", ^{

        __block Student *sut;
        
        beforeEach(^{
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
            
            xit(@"should update relationship 1:1", ^{
                // add national number
            });
            
            it(@"should update relationship 1:m", ^{
                id course = @{@"uid": @1, @"name": @"Software Engineering"};
                id data = @{@"uid": @1, @"course": course};
                [Student updateObject:sut withData:data];
                
                Course *item = sut.course;
                [[item.uid should] equal:[course objectForKey:@"uid"]];
                [[item.name should] equal:[course objectForKey:@"name"]];
            });
            
            it(@"should update relationship m:n", ^{
                id module = @{@"uid": @1, @"name": @"iOS Application Programming"};
                id data = @{@"uid": @1, @"modules": @[module]};
                [Student updateObject:sut withData:data];
                
                [[sut.modules should] haveCountOf:1];
                
                Module *item = [[sut.modules allObjects] objectAtIndex:0];
                [[item.uid should] equal:[module objectForKey:@"uid"]];
                [[item.name should] equal:[module objectForKey:@"name"]];
            });
            
            it(@"should update related object of [NSManagedObject class]", ^{
                
            });

            xit(@"should update related object of [NSNumber class]", ^{
                
            });
            
            xit(@"should update related object of [NSString class]", ^{
                
            });
            
            xit(@"should update related object of [NSDictionary class]", ^{
                
            });
        });
    });
    
    describe(@"+", ^{
        
    });
});

SPEC_END
