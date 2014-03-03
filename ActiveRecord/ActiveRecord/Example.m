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
    
    Student *student = [Student create];
    student.firstName = @"John";
    student.lastName = @"Doe";
    student.age = @21;
    
    [Student commit];
}

@end
