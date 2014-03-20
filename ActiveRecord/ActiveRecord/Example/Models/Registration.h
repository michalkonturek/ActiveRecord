//
//  Registration.h
//  ActiveRecord
//
//  Created by Michal Konturek on 20/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface Registration : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * digitalSignature;
@property (nonatomic, retain) Student *student;

@end
