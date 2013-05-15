//
//  RBLCIncrementalStore.m
//  RBLChecker
//
//  Created by Nick Pack on 15/05/2013.
//  Copyright (c) 2013 Nick Pack. All rights reserved.
//

#import "RBLCIncrementalStore.h"
#import "RBLCheckerAPIClient.h"

@implementation RBLCIncrementalStore

+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

+ (NSManagedObjectModel *)model {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RBLChecker" withExtension:@"xcdatamodeld"]];
}

- (id <AFIncrementalStoreHTTPClient>)HTTPClient {
    return [RBLCheckerAPIClient sharedClient];
}


@end
