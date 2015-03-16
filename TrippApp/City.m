//
//  City.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-03-12.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "City.h"

@implementation City

+ (NSMutableArray*) parseCityArray: (NSArray*)response
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (id object in response) {
        
        City* city = [City alloc];
        
        city.city_id = [object objectForKey:@"id"];
        city.city_name = [object objectForKey:@"name"];
        city.state_name = [object objectForKey:@"state"];
        city.country_name = [object objectForKey:@"country"];
        city.lat_airport = [object objectForKey:@"airport_lat"];
        city.lng_airport = [object objectForKey:@"airport_lng"];
        city.lat_city = [object objectForKey:@"lat"];
        city.lng_city = [object objectForKey:@"lng"];
        
        [result addObject:city];
        
    }
    
    return result;
}

@end
