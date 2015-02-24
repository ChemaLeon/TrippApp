//
//  APIServiceManager.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-17.
//  Copyright (c) 2015 TrippApp. All rights reserved.
//

#import "APIServiceManager.h"
#import "Trip.h"
#import <AFNetworking/AFNetworking.h>

NSString *const serverURL = @"http://trippapp-salsastudio.rhcloud.com/";


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



@end
