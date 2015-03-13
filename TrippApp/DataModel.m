//
//  MockDataModel.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "DataModel.h"
#import "Trip.h"
#import "Event.h"

@implementation DataModel

// Define Two pointers to hold both the Trip objects and the Event objects.
NSMutableArray* trips;
NSMutableArray* vancouverEvents;

// Generate and return mock data for use
+(NSArray*) getAllTrips {
    
    //TODO: Use '[UrlRequester GetJsonObjectsFrom:@"http://azber.net/trippapp/" WithCallback:@selector(finishedCall:) FromSource:self];'
    //to populate the trips data model and the events.
    
    // Populate the array with all the different Event instances which will be assigned to a trip.
    vancouverEvents = [NSMutableArray arrayWithObjects:
                       [[Event alloc] initWithLocationName:@"King Street Plaza"
                                                   Details:@"Christmas Market"
                                                   AndDate:@"20/02/2015 4:00 PM"],
                       [[Event alloc] initWithLocationName:@"Shinyoku Sushi"
                                                   Details:@"Dinner"
                                                   AndDate:@"20/02/2015 6:00 PM"],
                       [[Event alloc] initWithLocationName:@"Holiday Inn Downtown"
                                                   Details:@"Theater Showing"
                                                   AndDate:@"20/02/2015 8:00 PM"],
                       nil];
    
    // Populate the array with all the different Trip instances.
    trips = [NSMutableArray arrayWithObjects:
             [[Trip alloc] initWithLocationName:@"Vancouver"
                                        Details:@"Christmas & New Year Holidays"
                                    ArrivalDate:[self nsstringToNsdate:@"20/02/2015"]
                                  DepartureDate:[self nsstringToNsdate:@"20/02/2015"]],
             [[Trip alloc] initWithLocationName:@"Chicago"
                                        Details:@"Q1 Business Meeting"
                                    ArrivalDate:[self nsstringToNsdate:@"22/03/2015"]
                                  DepartureDate:[self nsstringToNsdate:@"22/03/2015"]],
             [[Trip alloc] initWithLocationName:@"Montreal"
                                        Details:@"Business Management Conference 2015"
                                    ArrivalDate:[self nsstringToNsdate:@"24/04/2015"]
                                  DepartureDate:[self nsstringToNsdate:@"24/04/2015"]],
             [[Trip alloc] initWithLocationName:@"Orlando"
                                        Details:@"Spring Break Holidays"
                                    ArrivalDate:[self nsstringToNsdate:@"26/05/2015"]
                                  DepartureDate:[self nsstringToNsdate:@"26/05/2015"]],
             nil];
    
    ((Trip*)trips[0]).events = vancouverEvents;
    ((Trip*)trips[1]).events = vancouverEvents;
    ((Trip*)trips[2]).events = vancouverEvents;
    ((Trip*)trips[3]).events = vancouverEvents;
    
    ((Trip*)trips[0]).cityLocationCoordinates = [[Location alloc] initWithLatitude:[NSNumber numberWithFloat:(49.264281f)]
                                                                      AndLongitude:[NSNumber numberWithFloat:(-123.078053f)]];
    
    ((Trip*)trips[1]).cityLocationCoordinates = [[Location alloc] initWithLatitude:[NSNumber numberWithFloat:(41.8781f)]
                                                                      AndLongitude:[NSNumber numberWithFloat:(-87.6292f)]];
    
    ((Trip*)trips[2]).cityLocationCoordinates = [[Location alloc] initWithLatitude:[NSNumber numberWithFloat:(45.501648f)]
                                                                      AndLongitude:[NSNumber numberWithFloat:(-73.486626f)]];
    
    ((Trip*)trips[3]).cityLocationCoordinates = [[Location alloc] initWithLatitude:[NSNumber numberWithFloat:(28.538069f)]
                                                                      AndLongitude:[NSNumber numberWithFloat:(-81.339239f)]];
    
    //Return the array of Trip objects to any requester.
    return trips;
}

+ (void)AddTrip:(Trip*)newTrip {
    [trips addObject:newTrip];
    //[self printTrips];
}

+ (void) printTrips {
    for (int i = 0; i < trips.count; i++) {
        Trip* tripObject = trips[i];
        NSLog(@"Trip Name: %@",tripObject.locationName);
        for (int j = 0; j < ((Trip*)trips[i]).events.count; j++) {
            Event* tripEvent = tripObject.events[j];
            NSLog(@"Event Name: %@",tripEvent.locationName);
        }
    }
}

+(NSDate*)nsstringToNsdate:(NSString*)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    //NSLog(@"String: %@", dateFromString);
    return [dateFormatter dateFromString:string];
}

+(NSDate*)nsstringToNstimedate:(NSString*)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy h:mm a"];
    //NSLog(@"Date: %@", dateFromString);
    //NSLog(@"String: %@", string);
    return [dateFormatter dateFromString:string];
}

+(NSString*)nsdateToNstring:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}

+(NSString*)nstimedateToNstring:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    //NSLog(@"Date: %@", date);
    //NSLog(@"String: %@", stringDate);
    return stringDate;
}

@end
