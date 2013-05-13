//
//  RBLCAPIClientTest.m
//  RBLChecker
//
//  Created by Nick Pack on 13/05/2013.
//  Copyright (c) 2013 Nick Pack. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "RBLCheckerAPIClient.h"

@interface RBLCAPIClientTest : GHAsyncTestCase { }
@end

@implementation RBLCAPIClientTest

- (void)testBaseURL {
    RBLCheckerAPIClient *apiClient = [RBLCheckerAPIClient sharedClient];
    GHAssertEqualStrings([apiClient.baseURL absoluteString], @"https://rblchecker.herokuapp.com/", @"The Base URL property for the API client should be https://rblchecker.herokuapp.com/");
}

- (void)testListsRequest {
    [self prepare];

    [[RBLCheckerAPIClient sharedClient] getPath:@"lists.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id result) {
        if (!result) {
            GHTestLog(@"result from remote service was unexpectedly nil.");
            [self notify:kGHUnitWaitStatusFailure forSelector:_cmd];
            return;
        }
        
        [self notify:kGHUnitWaitStatusSuccess forSelector:_cmd];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GHTestLog(@"Error encountered during lists json retrieval: %@", [error localizedDescription]);
        [self notify:kGHUnitWaitStatusFailure forSelector:_cmd];
    }];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:30.0];

}

- (void)testLookupRequest {
    [self prepare];
    [[RBLCheckerAPIClient sharedClient] getPath:@"/check/192.81.221.92/zen.spamhaus.org" parameters:nil success:^(AFHTTPRequestOperation *operation, id result) {
        if (!result) {
            GHTestLog(@"result from remote service was unexpectedly nil.");
            [self notify:kGHUnitWaitStatusFailure forSelector:_cmd];
            return;
        }

        [self notify:kGHUnitWaitStatusSuccess forSelector:_cmd];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        GHTestLog(@"Error encountered during lookup retrieval: %@", [error localizedDescription]);
        [self notify:kGHUnitWaitStatusFailure forSelector:_cmd];
    }];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:30.0];
    
}

@end
