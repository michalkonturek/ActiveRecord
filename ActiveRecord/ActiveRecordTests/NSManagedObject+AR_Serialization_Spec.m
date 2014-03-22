//
//  NSManagedObject+AR_Serialization_Spec.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "ActiveRecord.h"
#import "Domain.h"
#import "Factory.h"

SPEC_BEGIN(NSManagedObject_AR_Serialization_Spec)

describe(@"NSManagedObject+AR_Serialization", ^{
    
    __block id uid = @100;
    __block id input = @{@"uid": uid,
                         @"age": @22,
                         @"firstName": @"Adam",
                         @"lastName": @"Smith"};
    
    describe(@"+createOrUpdateWithData", ^{
        
        beforeEach(^{
            [Student deleteAll];
        });
        
        context(@"when an object with specified PK exists", ^{
            it(@"should not create another one", ^{
                [Student createWithID:uid];
                [[@([Student count]) should] equal:@1];
            });
        });
        
        context(@"when an object with specified PK does not exist", ^{
            it(@"should create new one", ^{
                [Student createOrUpdateWithData:input];
                [[@([Student count]) should] equal:@1];
            });
        });
    });
    
    describe(@"+update:withData", ^{

        __block Student *sut;
        
        beforeEach(^{
            [Factory deleteAll];
            sut = [Student createWithID:uid];
        });
        
        context(@"attributes", ^{
            it(@"should ignore null values", ^{
                [Student update:sut withData:input];
                
                id data = @{@"uid": uid, @"age": [NSNull null]};
                [Student update:sut withData:data];
                
                id object = [Student objectWithID:uid];
                [[[object age] should] equal:[input objectForKey:@"age"]];
            });
            
            it(@"should update object's attributes", ^{
                [Student update:sut withData:input];
                
                id object = [Student objectWithID:uid];
                
                [[[object uid] should] equal:[input objectForKey:@"uid"]];
                [[[object age] should] equal:[input objectForKey:@"age"]];
                [[[object firstName] should] equal:[input objectForKey:@"firstName"]];
                [[[object lastName] should] equal:[input objectForKey:@"lastName"]];
            });
        });
        
        context(@"relationships", ^{
            
            context(@"of null type are ignored", ^{
               
                it(@"in m:1 or m:n", ^{
                    id data = @{@"modules": [NSNull null]};
                    [Student update:sut withData:data];
                    [[sut.modules should] haveCountOf:0];
                });
                
                it(@"in 1:1", ^{
                    id object = @{@"uid": @1, @"signature": @"dlsgfjlaskdf"};
                    id data = @{@"uid": @1, @"registration": object};
                    [Student update:sut withData:data];
                    
                    data = @{@"registration": [NSNull null]};
                    [Student update:sut withData:data];
                    [[sut.registration shouldNot] beNil];
                });
            });
            
            context(@"are handled of type", ^{
                it(@"1:1", ^{
                    id json = @{@"uid": @1, @"signature": @"dlsgfjlaskdf"};
                    id data = @{@"uid": @1, @"registration": json};
                    [Student update:sut withData:data];
                    
                    [[sut.registration.uid should] equal:[json objectForKey:@"uid"]];
                    [[sut.registration.signature should] equal:[json objectForKey:@"signature"]];
                    [[sut.registration.student.uid should] equal:sut.uid];
                });
                
                it(@"1:m", ^{
                    id json = @{@"uid": @1, @"name": @"Software Engineering"};
                    id data = @{@"uid": @1, @"course": json};
                    [Student update:sut withData:data];
                    
                    [[sut.course.uid should] equal:[json objectForKey:@"uid"]];
                    [[sut.course.name should] equal:[json objectForKey:@"name"]];
                    [[sut.course.students should] haveCountOf:1];
                });
                
                it(@"m:n", ^{
                    id json = @{@"uid": @1, @"name": @"iOS Application Programming"};
                    id data = @{@"uid": @1, @"modules": @[json]};
                    [Student update:sut withData:data];
                    
                    [[sut.modules should] haveCountOf:1];
                    
                    Module *module = [[sut.modules allObjects] objectAtIndex:0];
                    [[module.uid should] equal:[json objectForKey:@"uid"]];
                    [[module.name should] equal:[json objectForKey:@"name"]];
                    [[module.students should] haveCountOf:1];
                });
            });
            
            context(@"with related object", ^{
                
                beforeEach(^{
                    [[Module createWithID:@1] setName:@"Module A"];
                    [[Module createWithID:@2] setName:@"Module B"];
                });
                
                it(@"of not supported type are ignored", ^{
                    id data = @{@"modules": @[[NSArray array]]};
                    [Student update:sut withData:data];
                    [[sut.modules should] haveCountOf:0];
                });
                
                it(@"of not null type are ignored", ^{
                    id data = @{@"modules": @[[NSNull null]]};
                    [Student update:sut withData:data];
                    [[sut.modules should] haveCountOf:0];
                });
                
                void (^validate)(void) = ^() {
                    [[sut.modules should] haveCountOf:2];
                    
                    id module = [[sut.modules allObjects] mk_match:^BOOL(id item) {
                        return ([[item uid] integerValue] == 1);
                    }];
                    [[[module name] should] equal:@"Module A"];
                    
                    module = [[sut.modules allObjects] mk_match:^BOOL(id item) {
                        return ([[item uid] integerValue] == 2);
                    }];
                    [[[module name] should] equal:@"Module B"];
                };
                

                
                it(@"pointed by NSNumber", ^{
                    id data = @{@"modules": @[@1, @2]};
                    [Student update:sut withData:data];
                    validate();
                });
                
                it(@"pointed by NSString", ^{
                    id data = @{@"modules": @[@"1", @"2"]};
                    [Student update:sut withData:data];
                    validate();
                });
                
                it(@"in form of NSDictionary", ^{
                    [Module deleteAll];
                    [Student update:sut withData:@{@"modules": @[
                                                           @{@"uid": @1, @"name": @"Module A"},
                                                           @{@"uid": @2, @"name": @"Module B"}
                                                           ]}];
                    validate();
                });
                
                it(@"in form of NSManagedObject", ^{
                    id data = @{@"modules": @[
                                        [Module objectWithID:@1],
                                        [Module objectWithID:@2]
                                        ]};
                    [Student update:sut withData:data];
                    validate();
                });
            });
            
        });
    });
});

SPEC_END
