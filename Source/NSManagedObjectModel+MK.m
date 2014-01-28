//
//  NSManagedObjectModel+MK.m
//  MKCoreData
//
//  Created by Michal Konturek on 01/06/2011.
//  Copyright (c) 2011 Michal Konturek. All rights reserved.
//

#import "NSManagedObjectModel+MK.h"


@implementation NSManagedObjectModel (MK)

static dispatch_once_t pred;
static NSManagedObjectModel *sharedManagedObject;


// MKTODO: document these functions in future
+ (NSManagedObjectModel *)managedObjectModel {
    
    dispatch_once(&pred, ^{
        NSArray *bundles = [NSArray arrayWithObject:[NSBundle mainBundle]];
//        sharedManagedObject = [[NSManagedObjectModel mergedModelFromBundles:bundles] retain];
        sharedManagedObject = [NSManagedObjectModel mergedModelFromBundles:bundles];
    });
    
    return sharedManagedObject;
}

+ (NSManagedObjectModel *)managedObjectModelWithName:(NSString *)modelName {
    
    dispatch_once(&pred, ^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        sharedManagedObject = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    });
    
    return sharedManagedObject;    
}


@end

