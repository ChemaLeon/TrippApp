//
//  Event.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-14.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "Event.h"

@implementation Event

+ (NSMutableArray*) parseEventArray: (NSArray*)response
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (id object in response) {
        
        Event* event = [Event alloc];
        
        event.trip_location_id = [object objectForKey:@"id"];
        event.event_date   = [object objectForKey:@"date"];
        event.period = [object objectForKey:@"period"];
        event.dismissed = [object objectForKey:@"dismissed"];
        
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
            event.location_id = [object objectForKey:@"location_id"];
            event.event_type   = @"L";
            event.name   = [object objectForKey:@"loc_name"];
            event.lat    = [object objectForKey:@"loc_lat"];
            event.lng    = [object objectForKey:@"loc_lng"];
            event.phone    = [object objectForKey:@"loc_phone"];
            event.website    = [object objectForKey:@"loc_website"];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            event.price    = [f numberFromString:[object objectForKey:@"price"]];
            [self getEventImage:event];

        }
        else
        {
            event.event_type   = @"N";
        }
        
        if([event.dismissed isEqualToString:@"1"])
        {
            event.name = @"Dismissed.";
        }
        
        [result addObject:event];
        
    }
    
    return result;
}

+ (void) getEventImage: (Event*) event
{
    NSString* imageUrl = [NSString stringWithFormat:@"http://trippapp-salsastudio.rhcloud.com/img/photos/locations/%@/%@.jpg", event.location_id, event.location_id];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            event.event_img = [UIImage imageWithData: data];
            
        });
        
    });
    
}

@end