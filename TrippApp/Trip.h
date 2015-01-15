//
//  Trip.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

// This class' purpose is to be a Data Model for a trip. It contains a location name, a description and a date intended for the trip to happen. To instantiate a new trip the developer must initialize the instance using the function inithWithLocationName, and introducing the trip information as parameters.

@interface Trip : NSObject

@property NSString * locationName;
@property NSString * details;
@property NSString * dateOfTrip;
@property NSArray * events;
@property Location * locationCoordinates;

- (id) init;
- (id) initWithLocationName:(NSString*)name Details:(NSString*)details AndDate:(NSString*)date;
- (void) setEvents:(NSArray *)events;

@end
