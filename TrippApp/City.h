//
//  City.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-03-12.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

//City Attributes
@property NSString * city_id;
@property NSString * city_name;
@property NSString * country_name;
@property NSString * lat_airport;
@property NSString * lng_airport;
@property NSString * lat_city;
@property NSString * lng_city;
@property NSString * state_name;

+ (NSMutableArray*) parseCityArray: (NSArray*)response;

@end
