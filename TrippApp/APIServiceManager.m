//
//  APIServiceManager.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-17.
//  Copyright (c) 2015 TrippApp. All rights reserved.
//

#import "APIServiceManager.h"
#import "City.h"
#import <AFNetworking/AFNetworking.h>

NSString *const serverURL = @"http://trippapp-salsastudio.rhcloud.com/";
//NSString *const serverURL = @"http://localhost:8083/";


@implementation APIServiceManager

/*
 *  Create New User - profile/newUser/
 *
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: User Key
 */

+ (void) createNewUser: (NSString*)observerName
{
    NSLog(@"NEW USER");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serviceURL = [serverURL stringByAppendingString:@"profile/newUser/"];
    [manager GET:serviceURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString* key = [responseObject objectForKey:@"key"];
             NSDictionary *dataDict = [NSDictionary dictionaryWithObject:key forKey:@"userKey"];
             [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:dataDict];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

/*
 *  Create New User - profile/newUser/
 *
 *  @PARAM:  userKey - User API Access Key
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of 10 Latest Trips for that User
 */

+ (void) getTripsFromUser: (NSString*)userKey withObserver: (NSString*)observerName
{
    NSLog(@"GET TRIPS");
    if([userKey length] > 0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *serviceURL = [serverURL stringByAppendingString:@"location/getUserTrips/"];
        [manager POST:serviceURL
           parameters:@{@"key": userKey}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSMutableArray* trips = [Trip parseTripArray:responseObject];
                  NSDictionary *dataDict = [NSDictionary dictionaryWithObject:trips forKey:@"trips"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:dataDict];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    
}

/*
 *  GetCities - location/getCities/
 *
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of Cities
 */

+ (void) getCitieswithObserver: (NSString*)observerName
{
    NSLog(@"GET CITIES");

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *serviceURL = [serverURL stringByAppendingString:@"location/getCities/"];
        [manager GET:serviceURL
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSMutableArray* cities = [City parseCityArray:responseObject];
                  NSDictionary *dataDict = [NSDictionary dictionaryWithObject:cities forKey:@"cities"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:dataDict];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    
}


/*
 *  Create New Trip - location/newTrip/
 *
 *  @PARAM:  userKey - User API Access Key
 *  @PARAM:  TripObject - Trip Object Containing the User Information
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of 10 Latest Trips for that User
 */

+ (void) createNewTrip:(Trip*)trip forUser: (NSString*)userKey withObserver: (NSString*)observerName
{
//    NSMutableArray* meetings = [NSMutableArray new];
    NSMutableDictionary *meetings = [[NSMutableDictionary alloc] init];
    int counter = 0;
    

        for (id object in trip.trip_events) {
            
            Event* event = (Event*) object;
            
            NSDictionary* meeting = @{@"name":event.name,
                                      @"lat":event.lat,
                                      @"lng":event.lng,
                                      @"begin_date_time":event.begin_date_time,
                                      @"end_date_time":event.end_date_time};
            
            [meetings setObject:meeting forKey:[NSNumber numberWithInt:counter]];
            counter++;
        }

    
//    NSData *meetingsJSON = [NSJSONSerialization dataWithJSONObject:meetings options:0 error:nil];

    if(trip.lat_hotel == nil)
    {
        trip.lat_hotel = @"";
        trip.lng_hotel = @"";
    }
    
    
    NSDictionary *parameters = @{
                             @"key": userKey,
                             @"city_id": trip.city_id,
                             @"date_arrival": trip.date_arrival,
                             @"date_departure": trip.date_departure,
                             @"lat_arrival": trip.lat_arrival,
                             @"lng_arrival": trip.lng_arrival,
                             @"lat_departure": trip.lat_departure,
                             @"lng_departure": trip.lng_departure,
                             @"lat_hotel": trip.lat_hotel,
                             @"lng_hotel": trip.lng_hotel,
                             @"meetings": meetings,
                             @"turist": @"1",
                             @"sport": @"1",
                             @"food": @"1",
                             @"party": @"1",
                             @"culture": @"1"
                             };
    
    NSLog(@"NEW TRIP");
    if([userKey length] > 0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *serviceURL = [serverURL stringByAppendingString:@"location/newTrip/"];
        [manager POST:serviceURL
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"Trip Generated");
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:nil];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    
}

/*
 *  Get the User's Tags - /profile/getUserTags/
 *
 *  @PARAM:  userKey - User API Access Key
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of 15 Random Tags
 */

+ (void) getTagsFromUser: (NSString*)userKey withObserver: (NSString*)observerName
{
    NSLog(@"GET TAGS");
    if([userKey length] > 0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *serviceURL = [serverURL stringByAppendingString:@"profile/getUserTags/"];
        [manager POST:serviceURL
           parameters:@{@"key": userKey}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //NSMutableArray* trips = [Trip parseTripArray:responseObject];
                  NSArray* tags = (NSArray*)responseObject;
                  NSDictionary *dataDict = [NSDictionary dictionaryWithObject:tags forKey:@"tags"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:dataDict];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    
}

/*
 *  Update the User's Taste - /profile/updateUserLifeStyle/
 *
 *  @PARAM:  userKey - User API Access Key
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of 15 Random Tags
 */

+ (void) updateUserTaste:(NSString*) taste withValue: (NSNumber*)value forUser: (NSString*)userKey withObserver: (NSString*)observerName
{
    NSLog(@"POST TASTES");
    if([userKey length] > 0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *serviceURL = [serverURL stringByAppendingString:@"profile/updateUserLifeStyle/"];
        [manager POST:serviceURL
           parameters:@{@"key": userKey, @"lifestyle":taste, @"value":[value stringValue]}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //NSMutableArray* trips = [Trip parseTripArray:responseObject];
                  NSArray* tags = (NSArray*)responseObject;
                  NSDictionary *dataDict = [NSDictionary dictionaryWithObject:tags forKey:@"tags"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:dataDict];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    
}

/*
 *  Get the User's Tags - /profile/getUserTastes/
 *
 *  @PARAM:  userKey - User API Access Key
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of 15 Random Tags
 */

+ (void) getTastesFromUser: (NSString*)userKey withObserver: (NSString*)observerName
{
    NSLog(@"GET TAGS");
    if([userKey length] > 0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *serviceURL = [serverURL stringByAppendingString:@"profile/getUserTastes/"];
        [manager POST:serviceURL
           parameters:@{@"key": userKey}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //NSMutableArray* trips = [Trip parseTripArray:responseObject];
                  NSArray* tags = (NSArray*)responseObject;
                  NSDictionary *dataDict = [NSDictionary dictionaryWithObject:tags forKey:@"tastes"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:dataDict];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    
}

/*
 *  Get the User's Tags - /location/newSuggestLocations/
 *
 *  @PARAM:  userKey - User API Access Key
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of 15 Random Tags
 */

+ (void) getNewSuggestLocation:(NSDictionary*)location forUser: (NSString*)userKey withObserver: (NSString*)observerName
{
    NSLog(@"GET NEW SUGGESTION");
    if([userKey length] > 0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *serviceURL = [serverURL stringByAppendingString:@"location/newSuggestLocations/"];
        [manager POST:serviceURL
           parameters:location
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  //NSMutableArray* trips = [Trip parseTripArray:responseObject];
                  NSArray* location = (NSArray*)responseObject;
                  NSDictionary *dataDict = [NSDictionary dictionaryWithObject:location forKey:@"location"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:dataDict];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    
}

/*
 *  Dismiss Location - /location/dismissLocation/
 *
 *  @PARAM:  userKey - User API Access Key
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of 15 Random Tags
 */

+ (void) dismissLocation:(NSDictionary*)location forUser: (NSString*)userKey withObserver: (NSString*)observerName
{
    NSLog(@"DISMISS LOCATION");
    if([userKey length] > 0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *serviceURL = [serverURL stringByAppendingString:@"location/dismissLocation/"];
        [manager POST:serviceURL
           parameters:location
              success:^(AFHTTPRequestOperation *operation, id responseObject) {

                  [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:nil];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    
}

/*
 *  GetLocation Tags - /location/getTagsByLocation/:location_id
 *
 *  @PARAM:  observerName - Name of the Observer to Notificate
 *  @RETURN: Populate Array of Cities
 */

+ (void) getTagsForLocation:(NSString*)location_id withObserver: (NSString*)observerName
{
    NSLog(@"GET TAGS FOR LOCATION");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serviceURL = [serverURL stringByAppendingString:[NSString stringWithFormat:@"location/getTagsByLocation/%@",location_id]];
    [manager GET:serviceURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray* tags = (NSArray*)responseObject;
             NSDictionary *dataDict = [NSDictionary dictionaryWithObject:tags forKey:@"tags"];
             [[NSNotificationCenter defaultCenter] postNotificationName:observerName object:nil userInfo:dataDict];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
}


@end
