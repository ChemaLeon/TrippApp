//
//  Event.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-14.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id) init {
    NSAssert(NO, @"init not allowed");
    return nil;
}

// Constructor
- (id) initWithLocationName:(NSString*)name Details:(NSString*)details AndDate:(NSString*)date {
    self = [super init];
    if (self) {
        self.locationName = name;
        self.details = details;
        self.event_date = date;
    }
    return self;
}

+ (NSMutableArray*) parseEventArray: (NSArray*)response
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (id object in response) {
        
        Event* event = [Event alloc];
        
        event.trip_location_id = [object objectForKey:@"id"];
        event.event_date   = [object objectForKey:@"date"];
        event.period = [object objectForKey:@"period"];
        
        //If it is a Meeting
        if(![[object objectForKey:@"meeting_id"] isEqualToString:@"0"])
        {
            event.event_type   = @"M";
            event.name   = [object objectForKey:@"meet_name"];
            event.lat    = [object objectForKey:@"meet_lat"];
            event.lng    = [object objectForKey:@"meet_lng"];
        }
        //If it is a Location
        else if (![[object objectForKey:@"location_id"] isEqualToString:@"0"])
        {
            event.event_type   = @"L";
            event.name   = [object objectForKey:@"loc_name"];
            event.lat    = [object objectForKey:@"loc_lat"];
            event.lng    = [object objectForKey:@"loc_lng"];
            event.phone    = [object objectForKey:@"loc_phone"];
            event.website    = [object objectForKey:@"loc_website"];

        }
        else
        {
            event.event_type   = @"N";
        }
        
        [result addObject:event];
        
    }
    
    return result;
}

@end