//
//  NSObject+RubySugar.h
//  RubySugar
//
//  Created by Michal Konturek on 22/08/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RubySugar)

/**
 Returns new array by concatenating object with input object.
 If argument is an array, all objects are concatenated.
 If target is an array, : on NSArray is executed.
 */
- (NSArray *):(id)object;

@end
