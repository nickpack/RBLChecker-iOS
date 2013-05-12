//
//  RBLCFQDNValidatorTest.m
//  RBLChecker
//
//  Created by Nick Pack on 12/05/2013.
//  Copyright (c) 2013 Nick Pack. All rights reserved.
//
#import <GHUnitIOS/GHUnit.h>
#import "RBLCInitialViewController.h"

@interface RBLCFQDNValidatorTest : GHTestCase { }
@end

@implementation RBLCFQDNValidatorTest

- (void)testValidFQDN {
    RBLCInitialViewController *initViewController = [[RBLCInitialViewController alloc] initWithCoder:nil];
    BOOL validationResult = [initViewController isValidFQDN:@"host.example.com"];

    GHAssertTrue(validationResult, @"A valid FQDN should return true");
}

- (void)testInvalidFQDN {
    RBLCInitialViewController *initViewController = [[RBLCInitialViewController alloc] initWithCoder:nil];
    BOOL validationResult = [initViewController isValidFQDN:@"^%&^%&%&*^%sddssd&&*^"];

    GHAssertFalse(validationResult, @"An invalid FQDN should return false");
}

@end
