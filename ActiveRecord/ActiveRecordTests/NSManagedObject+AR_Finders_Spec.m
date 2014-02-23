//
//  NSManagedObject+AR_Finders_Spec.m
//  ActiveRecord
//
//  Created by Michal Konturek on 23/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "ActiveRecord.h"
#import "Domain.h"
#import "Factory.h"

SPEC_BEGIN(NSManagedObject_AR_Finders_Spec)

describe(@"NSManagedObject_AR_Finders", ^{
    
    describe(@"+object", ^{
        
        beforeAll(^{
            [Student deleteAll];
            [Factory createStudents:20];
        });
       
        context(@"with ID", ^{
            it(@"should read only a specified object", ^{
                id item = [Student objectWithID:@1];
                [[[item uid] should] equal:@1];
                [[[item firstName] should] equal:@"firstName1"];
                [[[item lastName] should] equal:@"lastName1"];
                [[[item age] should] equal:@21];
            });
        });
        
        context(@"with predicate", ^{
            
        });

        context(@"with max value for attribute", ^{
            
        });
        
        context(@"with max value for attribute", ^{
            
        });
    });
    
    describe(@"+orderedBy", ^{
       
        context(@"ascending", ^{
            
            it(@"", ^{
                
            });
        });
        
        context(@"descending", ^{
            
            it(@"", ^{
                
            });
        });
    });
    
    describe(@"+objects", ^{
        
        NSInteger count = 20;
        
        beforeEach(^{
            [Student deleteAll];
            [Factory createStudents:count];
        });

        it(@"should return ALL objects", ^{
            [[[Student objects] should] haveCountOf:count];
        });

        context(@"with predicate", ^{
            
            it(@"should read only objects that match predicate", ^{
                id predicate = [NSPredicate predicateWithFormat:@"age >= 30"];
                [[[Student objectsWithPredicate:predicate] should] haveCountOf:10];
            });
            
        });
    });
    
});

SPEC_END
