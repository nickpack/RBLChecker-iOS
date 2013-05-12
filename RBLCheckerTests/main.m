//
//  main.m
//  RBLCheckerTests
//
//  Created by Nick Pack on 12/05/2013.
//  Copyright (c) 2013 Nick Pack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GHUnitIOS/GHUnitIOSViewController.h>

int main(int argc, char *argv[])
{
    int retVal;
    @autoreleasepool {
        if (getenv("GHUNIT_CLI")) {
            retVal = [GHTestRunner run];
        } else {
            retVal = UIApplicationMain(argc, argv, nil, @"GHUnitIOSAppDelegate");
        }
    }
    return retVal;
}