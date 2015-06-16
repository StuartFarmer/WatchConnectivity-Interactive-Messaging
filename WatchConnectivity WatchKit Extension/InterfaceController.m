//
//  InterfaceController.m
//  WatchConnectivity WatchKit Extension
//
//  Created by Stuart Farmer on 6/15/15.
//  Copyright © 2015 Stuart Farmer. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
@import UIKit;

@interface InterfaceController() <WCSessionDelegate> {
    WCSession *session;
}

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Start Watch Connectivity
    session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)sessionReachabilityDidChange:(nonnull WCSession *)session {
    NSLog(@"Session Reachability Changed!");
}

// Where ever the current instant of the defaultSession is will be where the delegate methods are called. Initally, they are called from the ExtensionDelegate, but after they are declared here, they will be called in this InterfaceController.
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message {

    // Check if the message is a termination message from the iOS app
    if ([message objectForKey:@"iOSAppTerminationOccuring"]) {
        // If it is, reopen to iOS app and restart location services because we require location services at all times this watch app is running.
        [self->session sendMessage:@{@"message":@"begin"} replyHandler:nil errorHandler:nil];
    }
    // Otherwise, output it.
    else {
        NSLog(@"Message recieved: %@", message);
        
        // Update UI
        [self.latitudeLabel setText:[NSString stringWithFormat:@"%@", [message objectForKey:@"latitude"]]];
        [self.longitudeLabel setText:[NSString stringWithFormat:@"%@", [message objectForKey:@"longitude"]]];
    }
}

- (IBAction)getLocationPressed {
    // Sends and inital message to the iOS app to begin location services. After this message is sent, the app is called into the background and location delegate methods are called.
    [session sendMessage:@{@"message":@"begin"} replyHandler:nil errorHandler:nil];
}
@end



