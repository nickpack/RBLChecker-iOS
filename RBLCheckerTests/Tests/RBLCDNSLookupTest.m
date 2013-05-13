//
//  RBLCDNSLookupTest.m
//  RBLChecker
//
//  Created by Nick Pack on 13/05/2013.
//  Copyright (c) 2013 Nick Pack. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "RBLCInitialViewController.h"

@interface RBLCDNSLookupTest : GHTestCase { }
@end

@implementation RBLCDNSLookupTest

- (void)testIPAddressLookup {
    RBLCInitialViewController *initViewController = [[RBLCInitialViewController alloc] initWithCoder:nil];
    NSString *ipAddress = [initViewController ipForHostname:@"loki.0xdeadfa11.net"];

    GHAssertEqualStrings(ipAddress, @"192.81.221.92", @"The IP Address returned for loki.0xdeadfa11.net should be 192.81.221.92");
}

@end

