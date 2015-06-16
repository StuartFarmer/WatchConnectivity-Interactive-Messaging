//
//  InterfaceController.h
//  WatchConnectivity WatchKit Extension
//
//  Created by Stuart Farmer on 6/15/15.
//  Copyright © 2015 Stuart Farmer. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *longitudeLabel;

- (IBAction)getLocationPressed;

@end
