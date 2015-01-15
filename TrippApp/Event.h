//
//  Event.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-14.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property NSString * locationName;
@property NSString * details;
@property NSString * hourOfEvent;

- (id) init;
- (id) initWithLocationName:(NSString*)name Details:(NSString*)details AndHour:(NSString*)date;

@end
