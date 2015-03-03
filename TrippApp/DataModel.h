//
//  MockDataModel.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

// This class is intended for the developers to populate the application's table with temporal data for testing purposes.

@interface DataModel : NSObject

+ (NSArray*) getAllTrips;
+ (void)AddTrip:(Trip*)newTrip;
+ (NSDate*)nsstringToNsdate:(NSString*)string;
+ (NSDate*)nsstringToNstimedate:(NSString*)string;
+ (NSString*)nsdateToNstring:(NSDate*)date;
+ (NSString*)nstimedateToNstring:(NSDate*)date;

@end
