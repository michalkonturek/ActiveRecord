//
//  Factory.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Factory : NSObject

+ (void)createStudents:(NSInteger)count;

+ (void)deleteAll;

+ (id)fixture100;
+ (id)fixture1000;
+ (id)fixture10000;

@end
