//
//  RBLCIPValidatorTest.m
//  RBLChecker
//
//  Created by Nick Pack on 12/05/2013.
//  Copyright (c) 2013 Nick Pack. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "RBLCInitialViewController.h"

@interface RBLCIPValidatorTest : GHTestCase { }
@end

@implementation RBLCIPValidatorTest

- (void)testValidIP4 {
    RBLCInitialViewController *initViewController = [[RBLCInitialViewController alloc] initWithCoder:nil];
    BOOL validationResult = [initViewController isValidIP:@"192.234.123.234" isV6:NO];

    GHAssertTrue(validationResult, @"A valid IPv4 Address should return true");
}

- (void)testInvalidIP4 {
    RBLCInitialViewController *initViewController = [[RBLCInitialViewController alloc] initWithCoder:nil];
    BOOL validationResult = [initViewController isValidIP:@"min.ge.ba.g" isV6:NO];

    GHAssertFalse(validationResult, @"An invalid IPv4 Address should return false");
}

- (void)testValidIP6 {
    RBLCInitialViewController *initViewController = [[RBLCInitialViewController alloc] initWithCoder:nil];
    BOOL validationResult = [initViewController isValidIP:@"2620:0:1cfe:face:b00c::3" isV6:YES];

    GHAssertTrue(validationResult, @"A valid IPv6 Address should return true");
}

- (void)testInvalidIP6 {
    RBLCInitialViewController *initViewController = [[RBLCInitialViewController alloc] initWithCoder:nil];
    BOOL validationResult = [initViewController isValidIP:@"99999:f00:m1nge:face:b00c::3" isV6:YES];

    GHAssertFalse(validationResult, @"An invalid IPv6 Address should return false");
}

@end
