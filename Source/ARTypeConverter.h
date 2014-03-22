//
//  ARTypeConverter.h
//  ActiveRecord
//
//  Created by Michal Konturek on 19/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ARTypeConverter : NSObject

+ (instancetype)create;

- (id)convert:(id)value toAttributeType:(NSAttributeType)type;
- (id)convertString:(NSString *)value toAttributeType:(NSAttributeType)type;

- (id)convertNilToNSNull:(id)value;
- (id)convertNSNullToNil:(id)value;


+ (id)convertValue:(id)value toDataType:(NSAttributeType)type;
+ (id)convertString:(NSString *)value toDataType:(NSAttributeType)type;

//+ (NSNumber *)convertNSStringToNSNumberOrNSNull:(NSString *)value;
+ (NSNumber *)convertNSStringToNSNumber:(NSString *)value;

//+ (NSNumber *)convertNSStringToNSNumberLongOrNSNull:(NSString *)value;
//+ (NSNumber *)convertNSStringToNSNumberLong:(NSString *)value;

//+ (NSNumber *)convertNSStringToNSNumberBool:(NSString *)value;
+ (BOOL)convertNSStringToBool:(NSString *)value;

+ (id)convertNilToNSNull:(id)value;
+ (id)convertNSNullToNil:(id)value;

@end
