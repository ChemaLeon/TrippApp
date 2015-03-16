//
//  Trip.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Event.h"

// This class' purpose is to be a Data Model for a trip. It contains a location name, a description and a date intended for the trip to happen. To instantiate a new trip the developer must initialize the instance using the function inithWithLocationName, and introducing the trip information as parameters.

@interface Trip : NSObject

//Trip Attributes
@property NSString * trip_id;
@property NSString * city_id;
@property NSString * city_name;
@property NSString * country_name;
@property NSString * date_arrival;
@property NSString * date_departure;
@property NSString * lat_arrival;
@property NSString * lat_departure;
@property NSString * lat_hotel;
@property NSString * lng_arrival;
@property NSString * lng_departure;
@property NSString * lng_hotel;
@property NSString * state_name;
//User Tastes
@property NSString * tourist;
@property NSString * food;
@property NSString * party;
@property NSString * sport;
@property NSString * culture;
//Array of Events
@property NSMutableArray * trip_events;

+ (NSMutableArray*) parseTripArray: (NSArray*)response;

@end
