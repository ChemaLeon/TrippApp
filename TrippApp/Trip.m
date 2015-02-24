//
//  Trip.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "Trip.h"
#import "Event.h"




@implementation Trip

-(id) init {
    NSAssert(NO, @"init not allowed");
    return nil;
}

// Constructor
- (id) initWithLocationName:(NSString*)name Details:(NSString*)details ArrivalDate:(NSDate*)adate DepartureDate:(NSDate*)ddate {
    self = [super init];
    if (self) {
        _locationName = name;
        _details = details;
        _arrivalDate = adate;
    }
    return self;
}

- (id) initEmpty {
    self = [super init];
    return self;
}


+ (NSMutableArray*) parseTripArray: (NSArray*)response
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (id object in response) {
        
        Trip* trip = [Trip alloc];
        
        trip.city_id = [object objectForKey:@"city_id"];
        trip.city_name = [object objectForKey:@"city_name"];
        trip.state_name = [object objectForKey:@"state_name"];
        trip.country_name = [object objectForKey:@"country_name"];
        trip.date_arrival = [object objectForKey:@"date_arrival"];
        trip.date_departure = [object objectForKey:@"date_departure"];
        trip.lat_arrival = [object objectForKey:@"lat_arrival"];
        trip.lat_departure = [object objectForKey:@"lat_departure"];
        trip.lat_hotel = [object objectForKey:@"lat_hotel"];
        trip.lng_arrival = [object objectForKey:@"lng_arrival"];
        trip.lng_departure = [object objectForKey:@"lng_departure"];
        trip.lng_hotel = [object objectForKey:@"lng_hotel"];
        trip.tourist = [object objectForKey:@"turist"];
        trip.food = [object objectForKey:@"food"];
        trip.party = [object objectForKey:@"party"];
        trip.sport = [object objectForKey:@"sport"];
        trip.culture = [object objectForKey:@"culture"];
        trip.trip_id = [object objectForKey:@"id"];
        
        trip.trip_events = [Event parseEventArray:[object objectForKey:@"trip_locations"]];
        
        [result addObject:trip];
        
    }

    return result;
}

@end
