//
//  Vector2.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-14.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property NSNumber* latitude;
@property NSNumber* longitude;

- (id) init;
- (id) initWithLatitude:(NSNumber*)latitude AndLongitude:(NSNumber*)longitude;

@end
