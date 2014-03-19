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
    
    // create an entity
    Student *student = [Student create];
    student.firstName = @"Adam";
    student.lastName = @"Smith";
    student.age = @21;
    
    // commit changes in context
    [Student commit];
    
    [student delete];
    [Student deleteAll];
    
    // rollback context to last commit
    [Student rollback];
    
    [Student objects];
    [Student objects:@"age > 20"];
    [Student objects:@"lastName == 'Smith'"];
    [Student objects:@{@"age": @21, @"lastName": @"Smith"}];
    
    [Student ordered:@"lastName, age"]; // orders by name, age ASC
    [Student ordered:@"lastName, !age"]; // orders by name ASC, age DESC
    
    [Student deleteAll];
    [Student commit];
}

@end
