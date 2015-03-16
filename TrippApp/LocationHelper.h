//
//  LocationHelper.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-03-14.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper : NSObject

+ (CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr;

@end
