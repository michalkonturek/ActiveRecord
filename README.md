# ActiveRecord

[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](https://github.com/michalkonturek/ActiveRecord/blob/master/LICENSE)
[![Build Platform](https://cocoapod-badges.herokuapp.com/p/ActiveRecord/badge.png)](https://github.com/michalkonturek/ActiveRecord)
[![Build Version](https://cocoapod-badges.herokuapp.com/v/ActiveRecord/badge.png)](https://github.com/michalkonturek/ActiveRecord)
[![Build Status](https://travis-ci.org/michalkonturek/ActiveRecord.png?branch=master)](https://travis-ci.org/michalkonturek/ActiveRecord)

A lightweight Active Record implementation for Core Data.

## License

Source code of this project is available under the standard MIT license. Please see [the license file][LICENSE].

[PODS]:http://cocoapods.org/
[LICENSE]:https://github.com/michalkonturek/ActiveRecord/blob/master/LICENSE


## Usage

Simply import `#import "ActiveRecord.h"` (please see [example][EXAMPLE])

[EXAMPLE]:https://github.com/michalkonturek/ActiveRecord/blob/master/ActiveRecord/ActiveRecord/Example/Example.m

```objc
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

[Student objects];
[Student objects:@"age > 20"];
[Student objects:@"lastName == 'Smith'"];
[Student objects:@{@"age": @21, @"lastName": @"Smith"}];

[Student ordered:@"lastName, age"]; // orders by name ASC, age ASC
[Student ordered:@"lastName, !age"]; // orders by name ASC, age DESC

[Student objects:@"age > 20" ordered:@"!age"];

```

### JSON Serialization

TBA

### Background Processing

TBA

### Integration with `mogenerator`

TBA


# API

## `NSManagedObject+AR`

```objc
+ (instancetype)createWithAutoID;
+ (instancetype)createWithID:(NSNumber *)objectID;
+ (instancetype)create;

+ (NSEntityDescription *)entityDescription;
+ (NSString *)entityName;
+ (NSString *)primaryKey;

+ (void)deleteAll;

- (void)assignAutoID;
- (void)delete;
```


## `NSManagedObject+AR_Finders`

```objc
+ (BOOL)hasObjects;
+ (BOOL)hasObjects:(id)condition;
+ (BOOL)hasObjectsWithPredicate:(NSPredicate *)predicate;

+ (NSInteger)count;
+ (NSInteger)count:(id)condition;
+ (NSInteger)countWithPredicate:(NSPredicate *)predicate;

+ (instancetype)object:(id)condition;
+ (instancetype)objectWithID:(NSNumber *)objectID;
+ (instancetype)objectWithPredicate:(NSPredicate *)predicate;
+ (instancetype)objectWithMaxValueFor:(NSString *)attribute;
+ (instancetype)objectWithMinValueFor:(NSString *)attribute;

+ (NSArray *)orderedAscendingBy:(NSString *)key;
+ (NSArray *)orderedDescendingBy:(NSString *)key;
+ (NSArray *)ordered:(id)order;

+ (NSArray *)objects;
+ (NSArray *)objects:(id)condition;
+ (NSArray *)objects:(id)condition ordered:(id)order;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate
               withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate
              withSortDescriptors:(NSArray *)descriptors;
```


## `NSPredicate+AR`

```objc
+ (instancetype)and:(NSArray *)conditions;
+ (instancetype)or:(NSArray *)conditions;

+ (instancetype)and:(id)cond1 :(id)cond2;
+ (instancetype)or:(id)cond1 :(id)cond2;

+ (instancetype)createFrom:(id)object;

- (instancetype)and:(id)condition;
- (instancetype)or:(id)condition;
```


## `NSSortDescriptor+AR`

```objc
+ (NSArray *)descriptors:(id)object;
+ (instancetype)create:(id)object;
+ (instancetype)createWithKey:(NSString *)key ascending:(BOOL)ascending;
```


## `NSManagedObjectContext+AR`

```objc
+ (instancetype)managedObjectContext;
+ (instancetype)mainContext;
+ (instancetype)backgroundContext;
+ (void)removeBackgroundContext;
+ (void)setBackgroundContext:(NSManagedObjectContext *)context;
```


## `NSManagedObjectContext+AR_Request`

```objc
+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate
                      withSortDescriptor:(NSSortDescriptor *)descriptor;

+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate
                     withSortDescriptors:(NSArray *)descriptors;
```


## `NSFetchRequest+AR`

```objc
+ (instancetype)createWithPredicate:(NSPredicate *)predicate
                 withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (instancetype)createWithPredicate:(NSPredicate *)predicate
                withSortDescriptors:(NSArray *)descriptors;
```

<!--
- - -

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/michalkonturek/activerecord/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
-->