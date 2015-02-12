//
//  Trip.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "Trip.h"

@implementation Trip

-(id) init {
    NSAssert(NO, @"init not allowed");
    return nil;
}

// Constructor
- (id) initWithLocationName:(NSString*)name Details:(NSString*)details ArrivalDate:(NSDate*)adate DepartureDate:(NSDate*)ddate {
    self = [super init];
    if (self) {
        _locationName = name;
        _details = details;
        _arrivalDate = adate;
    }
    return self;
}

- (id) initEmpty {
    self = [super init];
    return self;
}

@end
