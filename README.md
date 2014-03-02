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


# API

## `NSManagedObject+AR`

```
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

```
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

## `NSManagedObjectContext+AR`

```
+ (instancetype)managedObjectContext;
+ (instancetype)mainContext;
+ (instancetype)backgroundContext;
+ (void)removeBackgroundContext;
+ (void)setBackgroundContext:(NSManagedObjectContext *)context;
```


## `NSFetchRequest+AR`

```
+ (instancetype)createWithPredicate:(NSPredicate *)predicate
                 withSortDescriptor:(NSSortDescriptor *)descriptor;
+ (instancetype)createWithPredicate:(NSPredicate *)predicate
                withSortDescriptors:(NSArray *)descriptors;
```


## `NSPredicate+AR`

```
+ (instancetype)and:(NSArray *)conditions;
+ (instancetype)or:(NSArray *)conditions;

+ (instancetype)and:(id)cond1 :(id)cond2;
+ (instancetype)or:(id)cond1 :(id)cond2;

+ (instancetype)createFrom:(id)object;

- (instancetype)and:(id)condition;
- (instancetype)or:(id)condition;
```

## `NSSortDescriptor+AR`

```
+ (NSArray *)descriptors:(id)object;
+ (instancetype)create:(id)object;
+ (instancetype)createWithKey:(NSString *)key ascending:(BOOL)ascending;
```

- - -

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/michalkonturek/activerecord/trend.png)](https://bitdeli.com/free "Bitdeli Badge")