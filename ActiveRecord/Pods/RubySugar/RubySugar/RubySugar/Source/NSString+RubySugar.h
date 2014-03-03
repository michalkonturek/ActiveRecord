//
//  NSString+RubySugar.h
//  RubySugar
//
//  Created by Michal Konturek on 12/12/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RubySugar)

/**
 Returns new string by concatenating string with input object.
 Every object that responds to description selector is appended.
 */
- (NSString *):(id)object;

/**
 Returns self[@"<from>..<to>"]
 */
- (NSString *):(NSInteger)from :(NSInteger)to;

/**
 Returns self[@"<from>..<to>"] or Returns self[@"<from>...<to>"] if exclusive.
 */
- (NSString *):(NSInteger)from :(NSInteger)to exclusive:(BOOL)exclusive;

/**
 Returns an array of characters in string.
 */
- (NSArray *)rs_chars;

/**
 Returns true if string contains the given term.
 The default option is case sensitive.
 */
- (BOOL)rs_containsString:(NSString *)term;

/**
 Returns true if string contains the given term.
 */
- (BOOL)rs_containsString:(NSString *)term caseSensitive:(BOOL)caseSensitive;

/**
 Returns a copy of str with all characters in the intersection of its arguments deleted.
 Accepted input types is NSString or any id<NSFastEnumeration>.
 */
- (NSString *)rs_delete:(id)input;

/**
 Passes each character in str to the given block and returns self.
 If no block is given it returns enumerator instead.
 */
- (id)rs_eachChar:(void(^)(NSString *item))block;

/**
 Returns true if ([self length] == 0);
 */
- (BOOL)rs_isEmpty;

/**
 Shorthand for rs_justifyLeft with @" " pad.
 */
- (NSString *)rs_justifyLeft:(NSInteger)length;

/**
 If length is greater than the length of string, it returns a new string
 of [string lenght] + length which is left justified and padded with pad.
 Otherwise, returns self.
 */
- (NSString *)rs_justifyLeft:(NSInteger)length with:(NSString *)pad;

/**
 Shorthand for rs_justifyRight with @" " pad.
 */
- (NSString *)rs_justifyRight:(NSInteger)length;

/**
 If length is greater than the length of string, it returns a new string
 of [string lenght] + length which is right justified and padded with pad.
 Otherwise, returns self.
 */
- (NSString *)rs_justifyRight:(NSInteger)length with:(NSString *)pad;

/**
 Returns array of substrings, created by splitting str by a whitespace dellimeter.
 */
- (NSArray *)rs_split;

/**
 Divides str into substrings based on a delimiter, returning an array of these substrings.
 If pattern is a string then str is split on whitespace.
 If pattern is an empty string then str is split on character.
 If pattern is nil then str is split on whitespace.
 */
- (NSArray *)rs_split:(NSString *)pattern;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (id)objectForKeyedSubscript:(id<NSCopying>)key;

@end
