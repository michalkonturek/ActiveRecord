//
//  Factory.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "Factory.h"

#import "ActiveRecord.h"
#import "Domain.h"

@implementation Factory

+ (void)createStudents:(NSInteger)count {
    
    for (NSInteger idx = 0; idx < count; idx++) {
        Student *item = [Student createWithID:@(idx)];
        item.firstName = [NSString stringWithFormat:@"firstName%@", @(idx)];
        item.lastName = [NSString stringWithFormat:@"lastName%@", @(idx)];
        item.age = @(20 + idx);
    }
    
//    [Student commit];
}

+ (void)deleteAll {
    [Course deleteAll];
    [Module deleteAll];
    [Registration deleteAll];
    [Student deleteAll];
    [StudyGroup deleteAll];
}

@end
