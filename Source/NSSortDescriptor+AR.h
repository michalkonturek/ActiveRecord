//
//  NSSortDescriptor+AR.h
//  ActiveRecord
//
//  Created by Michal Konturek on 25/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSortDescriptor (AR)

+ (instancetype)createFrom:(id)object;
+ (instancetype)createWithKey:(NSString *)key ascending:(BOOL)ascending;

@end
