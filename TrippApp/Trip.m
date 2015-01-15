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
- (id) initWithLocationName:(NSString*)name Details:(NSString*)details AndDate:(NSString*)date {
    self = [super init];
    if (self) {
        _locationName = name;
        _details = details;
        _dateOfTrip = date;
    }
    return self;
}

@end
