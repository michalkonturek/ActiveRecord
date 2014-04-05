//
//  Factory.m
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
