//
//  Example.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "Example.h"

#import "ActiveRecord.h"
#import "Domain.h"

@implementation Example

+ (void)run {
    
    Student *student = [Student createObject];
    student.uid = @1;
    student.firstName = @"John";
    student.lastName = @"Doe";
    student.age = @21;
    
    [Student commit];
    
    id items = @[
                 [NSPredicate predicateWithFormat:@"age == 18"],
                 [NSPredicate predicateWithFormat:@"age == 28"]
                 ];
    id pred = [NSCompoundPredicate andPredicateWithSubpredicates:items];
    NSLog(@"%@", pred);
    
    items = @[
               pred,
               [NSPredicate predicateWithFormat:@"age > 100"]
              ];
    pred = [NSCompoundPredicate orPredicateWithSubpredicates:items];
    NSLog(@"%@", pred);
    
    id item = [Student objects];
    NSLog(@"%@", item[0]);
}

@end
