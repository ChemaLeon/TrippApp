//
//  Event.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-14.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id) init {
    NSAssert(NO, @"init not allowed");
    return nil;
}

// Constructor
- (id) initWithLocationName:(NSString*)name Details:(NSString*)details AndHour:(NSString*)hour {
    self = [super init];
    if (self) {
        _locationName = name;
        _details = details;
        _hourOfEvent = hour;
    }
    return self;
}

@end