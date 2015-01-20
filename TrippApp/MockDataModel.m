//
//  MockDataModel.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "MockDataModel.h"
#import "Trip.h"
#import "Event.h"

@implementation MockDataModel

// Generate and return mock data for use
+(NSArray*) GetAllTrips {
    
    // Define Two pointers to hold both the Trip objects and the Event objects.
    NSArray* trips;
    NSArray* vancouverEvents;
    
    // Populate the array with all the different Event instances which will be assigned to a trip.
    vancouverEvents = [NSArray arrayWithObjects:
                       [[Event alloc] initWithLocationName:@"King Street Plaza"
                                                   Details:@"Christmas Market"
                                                   AndHour:@"4:00 PM"],
                       [[Event alloc] initWithLocationName:@"Shinyoku Sushi"
                                                   Details:@"Dinner"
                                                   AndHour:@"6:00 PM"],
                       [[Event alloc] initWithLocationName:@"Holiday Inn Downtown"
                                                   Details:@"Theater Showing"
                                                   AndHour:@"8:30 PM"],
                       nil];
    
    Trip* van_trip = [[Trip alloc] initWithLocationName:@"Vancouver"
                               Details:@"Christmas & New Year Holidays"
                               AndDate:@"16/01/2015"];
    
    // Populate the array with all the different Trip instances.
    trips = [NSArray arrayWithObjects:
             van_trip,
             [[Trip alloc] initWithLocationName:@"Chicago"
                                        Details:@"Q1 Business Meeting"
                                        AndDate:@"20/02/2015"],
             [[Trip alloc] initWithLocationName:@"Montreal"
                                        Details:@"Business Management Conference 2015"
                                        AndDate:@"05/03/2015"],
             [[Trip alloc] initWithLocationName:@"Orlando"
                                        Details:@"Spring Break Holidays"
                                        AndDate:@"12/05/2015"],
             nil];
    
    van_trip.events = vancouverEvents;
    ((Trip*)trips[1]).events = vancouverEvents;
    ((Trip*)trips[2]).events = vancouverEvents;
    //((Trip*)trips[3]).events = vancouverEvents;
    
    van_trip.locationCoordinates = [[Location alloc] initWithLatitude:[NSNumber numberWithFloat:(49.264281f)]
                                                         AndLongitude:[NSNumber numberWithFloat:(-123.078053f)]];
    
    ((Trip*)trips[1]).locationCoordinates = [[Location alloc] initWithLatitude:[NSNumber numberWithFloat:(41.8781f)]
                                                                  AndLongitude:[NSNumber numberWithFloat:(-87.6292f)]];
    
    ((Trip*)trips[2]).locationCoordinates = [[Location alloc] initWithLatitude:[NSNumber numberWithFloat:(45.501648f)]
                                                                  AndLongitude:[NSNumber numberWithFloat:(-73.486626f)]];
    
    ((Trip*)trips[3]).locationCoordinates = [[Location alloc] initWithLatitude:[NSNumber numberWithFloat:(28.538069f)]
                                                                  AndLongitude:[NSNumber numberWithFloat:(-81.339239f)]];
    
    //Return the array of Trip objects to any requester.
    return trips;
}

@end
