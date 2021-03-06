//
//  AppDelegate.m
//  WatchConnectivity
//
//  Created by Stuart Farmer on 6/15/15.
//  Copyright © 2015 Stuart Farmer. All rights reserved.
//

#import "AppDelegate.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface AppDelegate () <WCSessionDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    WCSession *session;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Start Watch Connectivity for Interactive Messaging
    session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    
    // Start up location manager
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    locationManager.delegate = self;
    
    // Accuracy constants here. These should be tested for battery optimization.
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [locationManager startUpdatingLocation];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Send a message to the watch app to tell it that the background program is about to be closed, and to either reopen it or issue an error, as the location services will be terminated.
    [session sendMessage:@{@"message":@"iOSAppTerminationOccuring"} replyHandler:nil errorHandler:^(NSError * __nonnull error) {
        NSLog(@"Error sending termination message");
    }];
}
 
- (void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray *)locations {
    // Send the location to the watch app for processing
    CLLocation *lastLocation = [locations objectAtIndex:0];
    NSDictionary *locationDictionary = @{@"latitude" : @(lastLocation.coordinate.latitude), @"longitude" : @(lastLocation.coordinate.longitude)};
    
    [session sendMessage:locationDictionary replyHandler:^(NSDictionary<NSString *,id> * __nonnull replyMessage) {
        if ([[replyMessage objectForKey:@"message"] isEqualToString:@"error"]) {
            NSLog(@"Error in reply");
        }
    } errorHandler:^(NSError * __nonnull error) {
        NSLog(@"Error sending");
    }];
}

#pragma WCSessionDelegate Methods
// The staple session method that is called whenever a message is sent to the iOS app.
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    
    // In this case, the message content being sent from the app is a simple begin message. This tells the app to wake up and begin sending location information to the watch.
    if ([[message objectForKey:@"message"] isEqualToString:@"begin"]) {
        
        // Send an initial response for program brevity. Currently not using reply handles.
        NSDictionary *locationDictionary = @{@"latitude" : @([locationManager location].coordinate.latitude), @"longitude" : @([locationManager location].coordinate.longitude)};
        
        [self->session sendMessage:locationDictionary replyHandler:nil errorHandler:^(NSError * __nonnull error) {
            NSLog(@"Error sending");
        }];
    }
}

@end
