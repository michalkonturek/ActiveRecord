//
//  Module.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student, StudyGroup;

@interface Module : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) NSSet *studyGroups;
@end

@interface Module (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

- (void)addStudyGroupsObject:(StudyGroup *)value;
- (void)removeStudyGroupsObject:(StudyGroup *)value;
- (void)addStudyGroups:(NSSet *)values;
- (void)removeStudyGroups:(NSSet *)values;

@end
