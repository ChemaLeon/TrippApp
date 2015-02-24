//
//  APIServiceManager.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-17.
//  Copyright (c) 2015 TrippApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIServiceManager : NSObject

+ (void) createNewUser: (NSString*)observerName;
+ (void) getTripsFromUser: (NSString*)userKey withObserver: (NSString*)observerName;

@end


