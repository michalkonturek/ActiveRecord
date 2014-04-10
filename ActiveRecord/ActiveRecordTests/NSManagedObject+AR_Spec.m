//
//  NSManagedObjectSpec.m
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

SPEC_BEGIN(NSManagedObject_AR_Spec)

describe(@"NSManagedObject_AR", ^{

    describe(@"+create", ^{
        
        __block Student *sut;
        
        beforeEach(^{
            [Student deleteAll];
            [Student commit];
            sut = [Student create];
        });

        specify(^{
            [[sut shouldNot] beNil];
        });
        
        specify(^{
            [[sut should] beMemberOfClass:[Student class]];
        });
        
        it(@"should not commit changes", ^{
            [[[Student objects] should] haveCountOf:1];
            [Student rollback];
            [[[Student objects] should] haveCountOf:0];
        });
        
        context(@"with ID", ^{
            
            __block id uid = nil;
            
            beforeEach(^{
                [Student deleteAll];
                uid = @1;
                sut = [Student createWithID:uid];
            });
            
            it(@"should has ID", ^{
                [[sut.uid should] equal:uid];
            });
            
            it(@"should not create duplicate object with the same ID", ^{
                id other = [Student createWithID:uid];
                [[other should] equal:sut];
            });
        });
        
        context(@"with Auto ID", ^{
            
            NSInteger count = 20;
            beforeEach(^{
                [Student deleteAll];
                [Factory createStudents:count];
            });
            
            it(@"should create with 1 if first object", ^{
                [Student deleteAll];
                id result = [Student createWithAutoID];
                [[[result uid] should] equal:@1];
            });
            
            it(@"should create with 1 if other objects have no PK", ^{
                [[Student objects] mk_each:^(id item) {
                    [item setUid:nil];
                }];
                id result = [Student createWithAutoID];
                [[[result uid] should] equal:@1];
            });
            
            it(@"should create with succ number of MAX primary key", ^{
                id expected = @(count);
                id result = [Student createWithAutoID];
                [[[result uid] should] equal:expected];
            });
            
            it(@"should create with ID > 0", ^{
                [Student deleteAll];
                [Student createWithID:@-10];
                id result = [Student createWithAutoID];
                [[[result uid] should] beGreaterThan:@0];
            });
        });
    });
    
    describe(@"-assignAutoID", ^{
        
        beforeEach(^{
            [Student deleteAll];
        });
        
        context(@"if object already has positive ID", ^{
            it(@"should not assign new ID", ^{
                id expected = @1;
                id result = [Student createWithID:expected];
                [result assignAutoID];
                [[[result uid] should] equal:expected];
            });
        });
        
        context(@"if no objects with positive ID", ^{
            it(@"should assign default ID = 1", ^{
                [Student create];
                [Student createWithID:@-1];
                
                id result = [Student create];
                [result assignAutoID];
                [[[result uid] should] equal:@1];
            });
            
            it(@"should never assign below 1", ^{
                id result = [Student createWithID:@-1];
                [result assignAutoID];
                [[[result uid] should] equal:@1];
            });
            
        });
    });
    
    describe(@"+deleteAll", ^{
        
        NSInteger count = 20;
        beforeEach(^{
            [Student deleteAll];
            [Factory createStudents:count];
        });
        
        it(@"should delete all objects", ^{
            [[[Student objects] should] haveCountOf:count];
            [Student deleteAll];
            [[[Student objects] should] haveCountOf:0];
        });
        
    });
    
    describe(@"-delete", ^{
        
        it(@"should delete specified objects", ^{
            [Student createWithID:@1];
            [Student createWithID:@2];
            [[[Student objects] should] haveCountOf:2];
            
            [[Student objectWithID:@1] delete];
            
            [[[Student objectWithID:@1] should] beNil];
            [[[Student objects] should] haveCountOf:1];
        });
    });
    
    describe(@"-isTheSameAs:", ^{
        
        __block Student *sut;
        beforeAll(^{
            sut = [Student objectWithID:@1];
        });
        
        NSInteger count = 5;
        beforeEach(^{
            [Student deleteAll];
            [Factory createStudents:count];
        });

        context(@"when same uid", ^{
            specify(^{
                id other = [Student objectWithID:@1];
                [[@([sut isTheSame:other]) should] equal:@(YES)];
            });
        });
        
        context(@"when different uid", ^{
            specify(^{
                id other = [Student objectWithID:@2];
                [[@([sut isTheSame:other]) should] equal:@(NO)];
            });
        });
        
        context(@"when class mismatch", ^{
            specify(^{
                id other = [Course createWithID:@1];
                [[@([sut isTheSame:other]) should] equal:@(NO)];
            });
        });
    });
    
});

SPEC_END
