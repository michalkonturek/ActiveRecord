//
//  StudyGroup.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module, Student;

@interface StudyGroup : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) Module *module;
@property (nonatomic, retain) NSSet *students;
@end

@interface StudyGroup (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
