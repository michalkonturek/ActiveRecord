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

+ (id)fixture100 {
    return [self _loadDataFromFile:@"data-100"];
}

+ (id)fixture1000 {
    return [self _loadDataFromFile:@"data-1000"];
}

+ (id)fixture10000 {
    return [self _loadDataFromFile:@"data-10000"];
}

+ (id)_loadDataFromFile:(NSString *)filename {
    id path = [[NSBundle mainBundle] URLForResource:filename withExtension:@"json"];
    id json = [NSData dataWithContentsOfURL:path];
    return [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:nil];
}

@end
