//
//  DayPhase.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-20.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DayPhase : NSObject

@property NSString * phase_id;
@property UIColor * light_color;
@property UIColor * dark_color;
@property UIColor * route_color;
@property UIImage * clock;
@property UIImage * marker;
@property NSString * phase_name;

+ (NSArray*) getDayPhases;

@end
