//
//  RBLCBlacklist.m
//  RBLChecker
//
//  Created by Nick Pack on 11/05/2013.
//  Copyright (c) 2013 Nick Pack.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "RBLCBlacklist.h"
#import "RBLCheckerAPIClient.h"

@implementation RBLCBlacklist

@synthesize name = _name;
@synthesize endpoint = _endpoint;
@synthesize statusMessage = _statusMessage;
@synthesize listed = _listed;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    _name = [attributes valueForKeyPath:@"name"];
    _endpoint = [attributes valueForKeyPath:@"endpoint"];

    return self;
}

#pragma mark -

+ (void)listsWithBlock:(void (^)(NSArray *lists, NSError *error))block {
    [[RBLCheckerAPIClient sharedClient] getPath:@"lists.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *listsFromResponse = JSON;
        NSMutableArray *mutableLists = [NSMutableArray arrayWithCapacity:[listsFromResponse count]];
        for (NSDictionary *attributes in listsFromResponse) {
            RBLCBlacklist *post = [[RBLCBlacklist alloc] initWithAttributes:attributes];
            [mutableLists addObject:post];
        }

        if (block) {
            block([NSArray arrayWithArray:mutableLists], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
