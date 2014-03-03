# RubySugar

[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](https://github.com/michalkonturek/RubySugar/blob/master/LICENSE)
[![Build Platform](https://cocoapod-badges.herokuapp.com/p/RubySugar/badge.png)](https://github.com/michalkonturek/RubySugar)
[![Build Version](https://cocoapod-badges.herokuapp.com/v/RubySugar/badge.png)](https://github.com/michalkonturek/RubySugar)
[![Build Status](https://travis-ci.org/michalkonturek/RubySugar.png?branch=master)](https://travis-ci.org/michalkonturek/RubySugar)

## Intro

Ports Ruby syntactic sugar to Objective-C.

```obj-c
id numbers = @[@0, @1, @2, @3, @4, @5];
id result = numbers[@"1..4"];
// [1, 2, 3, 4]

result = numbers[@"1...4"];
// 2, 3]

result = [@[@1, @2]:@[@3, @4]];
// [1, 2, 3, 4]

result = [@[@1, @2]:@3];
// [1, 2, 3]

[@3 rs_timesWithIndex:^(NSInteger index) {
    NSLog(@"Line #%i", index);
}];
// Line #0
// Line #1
// Line #2

result = @"Vexilla regis."[1];
// e

result = @"Vexilla regis."[@"1..6"];
// exilla

result = @"Vexilla regis."[@"1...6"];
// xill

result = [[[@"Number " :@10] :@" is greater than "] :@5];
// Number 10 is greater than 5.

result = [@"Hello" rs_chars];
// ["H", "e", "l", "l", "o"]
```

## License

Source code of this project is available under the standard MIT license. Please see [the license file][LICENSE].

[PODS]:http://cocoapods.org/
[LICENSE]:https://github.com/michalkonturek/RubySugar/blob/master/LICENSE

# API

## `NSArray`

```obj-c
- (instancetype):(id)object;

- (instancetype):(NSInteger)from :(NSInteger)to;
- (instancetype):(NSInteger)from :(NSInteger)to exclusive:(BOOL)exclusive;

- (instancetype)rs_clear;

- (instancetype)rs_combination:(NSInteger)n;

- (instancetype)rs_compact;

- (instancetype)rs_delete:(id)object;
- (instancetype)rs_deleteAt:(NSInteger)index;
- (id)rs_deleteIf:(BOOL(^)(id item))block;

- (instancetype)rs_drop:(NSInteger)count;
- (id)rs_dropWhile:(BOOL(^)(id item))block;

- (id)rs_fetch:(NSUInteger)index;

- (instancetype)rs_flatten;
- (instancetype)rs_flatten:(NSInteger)level;

- (BOOL)rs_includes:(id)object;

- (BOOL)rs_isEmpty;

- (NSString *)rs_join;
- (NSString *)rs_join:(NSString *)separator;

- (instancetype)rs_permutation;
- (instancetype)rs_permutation:(NSInteger)n;

- (instancetype)rs_reverse;

- (id)rs_sample;
- (instancetype)rs_sample:(NSUInteger)count;

- (instancetype)rs_shuffle;

- (instancetype)rs_take:(NSInteger)count;
- (id)rs_takeWhile:(BOOL(^)(id item))block;

- (instancetype)rs_uniq;
- (instancetype)rs_uniq:(id(^)(id item))block;

- (instancetype)rs_zip;

```


## `NSNumber`

 
```objc
- (instancetype)rs_gcd:(NSInteger)other;

- (instancetype)rs_lcm:(NSInteger)other;

- (instancetype)rs_next;

- (instancetype)rs_pred;

- (id)rs_times:(void(^)(void))block;
- (id)rs_timesWithIndex:(void(^)(NSInteger index))block;

- (id)rs_downto:(NSInteger)limit do:(void(^)(NSInteger index))block;

- (id)rs_upto:(NSInteger)limit do:(void(^)(NSInteger index))block;

- (NSArray *)rs_numbersTo:(NSInteger)to;
```

## `NSString`

```obj-c

- (NSString *):(id)object;

- (NSString *):(NSInteger)from :(NSInteger)to;
- (NSString *):(NSInteger)from :(NSInteger)to exclusive:(BOOL)exclusive;

- (NSArray *)rs_chars;

- (BOOL)rs_containsString:(NSString *)term;
- (BOOL)rs_containsString:(NSString *)term caseSensitive:(BOOL)caseSensitive;

- (NSString *)rs_delete:(id)input;

- (id)rs_eachChar:(void(^)(NSString *item))block;

- (BOOL)rs_isEmpty;

- (NSString *)rs_justifyLeft:(NSInteger)length;
- (NSString *)rs_justifyLeft:(NSInteger)length with:(NSString *)pad;

- (NSString *)rs_justifyRight:(NSInteger)length;
- (NSString *)rs_justifyRight:(NSInteger)length with:(NSString *)pad;

- (NSArray *)rs_split;

- (NSArray *)rs_split:(NSString *)pattern;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (id)objectForKeyedSubscript:(id<NSCopying>)key;
```


- - -

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/michalkonturek/rubysugar/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
