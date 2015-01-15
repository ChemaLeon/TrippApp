//
//  Vector2.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-14.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@implementation Location

-(id) init {
    NSAssert(NO, @"init not allowed");
    return nil;
}

- (id) initWithLatitude:(NSNumber*)latitude AndLongitude:(NSNumber*)longitude {
    self = [super init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

@end