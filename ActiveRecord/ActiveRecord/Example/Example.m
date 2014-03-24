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
    
    // rollback context to last commit
    [student delete];
    [Student rollback];
    
    // fetch all Student objects
    [Student objects];
    
    // queries
    [Student objects:@"age > 20"];
    [Student objects:@"lastName == 'Smith'"];
    [Student objects:@{@"age": @21, @"lastName": @"Smith"}];
    
    // ordered queries
    [Student ordered:@"lastName, age"]; // orders by name ASC, age ASC
    [Student ordered:@"lastName, !age"]; // orders by name ASC, age DESC
    
    [Student objects:@"age > 20" ordered:@"!age"];

    // Erase all Student objects
    [Student deleteAll];
}

@end
