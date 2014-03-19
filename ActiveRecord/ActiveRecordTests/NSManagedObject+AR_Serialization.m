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

SPEC_BEGIN(NSManagedObject_AR_Serialization)

describe(@"NSManagedObject+AR_Serialization", ^{
    
    beforeEach(^{
        [Student deleteAll];
        [Student commit];
    });
    
    describe(@"+createOrUpdateObjectWithData", ^{
        
        
        
        
    });
    
//    describe(@"+createOrUpdateObjectWithData", ^{
//        
//    });
    
    
});

SPEC_END
