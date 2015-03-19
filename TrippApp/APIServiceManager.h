//
//  APIServiceManager.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-17.
//  Copyright (c) 2015 TrippApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface APIServiceManager : NSObject

+ (void) createNewUser: (NSString*)observerName;
+ (void) getTripsFromUser: (NSString*)userKey withObserver: (NSString*)observerName;
+ (void) getCitieswithObserver: (NSString*)observerName;
+ (void) createNewTrip:(Trip*)trip forUser: (NSString*)userKey withObserver: (NSString*)observerName;
+ (void) getTagsFromUser: (NSString*)userKey withObserver: (NSString*)observerName;
+ (void) updateUserTaste:(NSString*) taste withValue: (NSNumber*)value forUser: (NSString*)userKey withObserver: (NSString*)observerName;
+ (void) getNewSuggestLocation:(NSDictionary*)location forUser: (NSString*)userKey withObserver: (NSString*)observerName;
+ (void) dismissLocation:(NSDictionary*)location forUser: (NSString*)userKey withObserver: (NSString*)observerName;
+ (void) getTagsForLocation:(NSString*)location_id withObserver: (NSString*)observerName;

@end


