//
//  NSManagedObject+AR_Serialization_Spec.m
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
                [sut updateWithData:input];
                
                id data = @{@"uid": uid, @"age": [NSNull null]};
                [sut updateWithData:data];
                
                id object = [Student objectWithID:uid];
                [[[object age] should] equal:[input objectForKey:@"age"]];
            });
            
            it(@"should update object's attributes", ^{
                [sut updateWithData:input];
                
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
                    [sut updateWithData:data];
                    [[sut.modules should] haveCountOf:0];
                });
                
                it(@"in 1:1", ^{
                    id object = @{@"uid": @1, @"signature": @"dlsgfjlaskdf"};
                    id data = @{@"uid": @1, @"registration": object};
                    [sut updateWithData:data];
                    
                    data = @{@"registration": [NSNull null]};
                    [sut updateWithData:data];
                    [[sut.registration shouldNot] beNil];
                });
            });
            
            context(@"are handled of type", ^{
                it(@"1:1", ^{
                    id json = @{@"uid": @1, @"signature": @"dlsgfjlaskdf"};
                    id data = @{@"uid": @1, @"registration": json};
                    [sut updateWithData:data];
                    
                    [[sut.registration.uid should] equal:[json objectForKey:@"uid"]];
                    [[sut.registration.signature should] equal:[json objectForKey:@"signature"]];
                    [[sut.registration.student.uid should] equal:sut.uid];
                });
                
                it(@"1:m", ^{
                    id json = @{@"uid": @1, @"name": @"Software Engineering"};
                    id data = @{@"uid": @1, @"course": json};
                    [sut updateWithData:data];
                    
                    [[sut.course.uid should] equal:[json objectForKey:@"uid"]];
                    [[sut.course.name should] equal:[json objectForKey:@"name"]];
                    [[sut.course.students should] haveCountOf:1];
                });
                
                it(@"m:n", ^{
                    id json = @{@"uid": @1, @"name": @"iOS Application Programming"};
                    id data = @{@"uid": @1, @"modules": @[json]};
                    [sut updateWithData:data];
                    
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
                    [sut updateWithData:data];
                    [[sut.modules should] haveCountOf:0];
                });
                
                it(@"of not null type are ignored", ^{
                    id data = @{@"modules": @[[NSNull null]]};
                    [sut updateWithData:data];
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
                    [sut updateWithData:data];
                    validate();
                });
                
                it(@"pointed by NSString", ^{
                    id data = @{@"modules": @[@"1", @"2"]};
                    [sut updateWithData:data];
                    validate();
                });
                
                it(@"in form of NSDictionary", ^{
                    [Module deleteAll];
                    id data = @{@"modules": @[
                                        @{@"uid": @1, @"name": @"Module A"},
                                        @{@"uid": @2, @"name": @"Module B"}
                                        ]};
                    [sut updateWithData:data];
                    validate();
                });
                
                it(@"in form of NSManagedObject", ^{
                    id data = @{@"modules": @[
                                        [Module objectWithID:@1],
                                        [Module objectWithID:@2]
                                        ]};
                    [sut updateWithData:data];
                    validate();
                });
            });
            
        });
    });
});

SPEC_END
