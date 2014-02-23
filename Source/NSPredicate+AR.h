//
//  NSPredicate+AR.h
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (AR)

+ (instancetype)and:(NSArray *)conditions;
+ (instancetype)or:(NSArray *)conditions;

+ (instancetype)and:(id)cond1 :(id)cond2;
+ (instancetype)or:(id)cond1 :(id)cond2;

+ (instancetype)createFrom:(id)object;

- (instancetype)and:(id)condition;
- (instancetype)or:(id)condition;

@end
