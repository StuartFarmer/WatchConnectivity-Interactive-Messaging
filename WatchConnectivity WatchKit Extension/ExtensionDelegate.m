//
//  ExtensionDelegate.m
//  WatchConnectivity WatchKit Extension
//
//  Created by Stuart Farmer on 6/15/15.
//  Copyright © 2015 Stuart Farmer. All rights reserved.
//

#import "ExtensionDelegate.h"
#import <WatchConnectivity/WatchConnectivity.h>

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    // Start Watch Connectivity for Interactive Messaging
    WCSession *session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    
    // Check to see if the session is able to function
    if (session.isReachable) {
        NSLog(@"Able to reach app.");
    }
    
    // Cool. Carry on in Interface Controller.
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}

@end
