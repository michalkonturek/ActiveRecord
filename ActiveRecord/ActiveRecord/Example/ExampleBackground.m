//
//  ExampleBackground.m
//  ActiveRecord
//
//  Created by Michal Konturek on 23/03/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "ExampleBackground.h"

#import "ActiveRecord.h"
#import "Domain.h"

#import "Factory.h"

@implementation ExampleBackground

+ (void)run {
    [Factory deleteAll];
    id students = [Factory fixture1000];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [students mk_each:^(id item) {
            id student = [Student createOrUpdateWithData:item];
            NSLog(@"Loaded %@", [student uid]);
            [Student commit];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id item in [Student ordered:@"uid"]) {
                NSLog(@"%@: %@ %@", [item uid], [item firstName], [item lastName]);
            }
        });
    });
}

@end
