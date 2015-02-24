//
//  Event.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-14.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property NSString * locationName;
@property NSString * details;
@property NSString * hourOfEvent;


@property NSString * name;
@property NSString * event_date;
@property NSString * trip_location_id;
@property NSString * event_type;
@property NSString * lat;
@property NSString * lng;
@property NSString * period;
@property NSString * phone;
@property NSString * website;

- (id) init;
- (id) initWithLocationName:(NSString*)name Details:(NSString*)details AndHour:(NSString*)date;
+ (NSMutableArray*) parseEventArray: (NSArray*)response;

@end
