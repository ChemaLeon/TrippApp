//
//  DayPhase.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-20.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "DayPhase.h"

@implementation DayPhase

+ (NSArray*) getDayPhases
{
    
    DayPhase *menu = [DayPhase alloc];
    DayPhase *early_morning = [DayPhase alloc];
    DayPhase *morning = [DayPhase alloc];
    DayPhase *mid_day = [DayPhase alloc];
    DayPhase *afternoon = [DayPhase alloc];
    DayPhase *early_evening = [DayPhase alloc];
    DayPhase *evening = [DayPhase alloc];
    
    menu.phase_id = @"menu";
    menu.light_color = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    menu.dark_color = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:0.7];

    early_morning.phase_id = @"early_morning";
    early_morning.light_color = [UIColor whiteColor];
    early_morning.dark_color = [UIColor colorWithRed:113/255.0 green:148/255.0 blue:128/255.0 alpha:0.7];
    early_morning.route_color = [UIColor blackColor];
    early_morning.clock = [UIImage imageNamed:@"01Clock-EM"];
    early_morning.marker = [UIImage imageNamed:@"01marker"];
    early_morning.phase_name = @"sunrise";

    morning.phase_id = @"morning";
    morning.light_color = [UIColor whiteColor];
    morning.dark_color = [UIColor colorWithRed:189/255.0 green:170/255.0 blue:84/255.0 alpha:0.7];
    morning.route_color = [UIColor blackColor];
    morning.clock = [UIImage imageNamed:@"02Clock-Mor"];
    morning.marker = [UIImage imageNamed:@"02marker"];
    morning.phase_name = @"morning";
    
    mid_day.phase_id = @"mid_day";
    mid_day.light_color = [UIColor whiteColor];
    mid_day.dark_color = [UIColor colorWithRed:211/255.0 green:169/255.0 blue:109/255.0 alpha:0.7];
    mid_day.route_color = [UIColor blackColor];
    mid_day.clock = [UIImage imageNamed:@"03Clock-Mid"];
    mid_day.marker = [UIImage imageNamed:@"03marker"];
    mid_day.phase_name = @"midday";
    
    afternoon.phase_id = @"afternoon";
    afternoon.light_color = [UIColor whiteColor];
    afternoon.dark_color = [UIColor colorWithRed:171/255.0 green:112/255.0 blue:96/255.0 alpha:0.7];
    afternoon.route_color = [UIColor blackColor];
    afternoon.clock = [UIImage imageNamed:@"04Clock-Aft"];
    afternoon.marker = [UIImage imageNamed:@"04marker"];
    afternoon.phase_name = @"afternoon";
    
    early_evening.phase_id = @"early_evening";
    early_evening.light_color = [UIColor whiteColor];
    early_evening.dark_color = [UIColor colorWithRed:147/255.0 green:95/255.0 blue:91/255.0 alpha:0.7];
    early_evening.route_color = [UIColor blackColor];
    early_evening.clock = [UIImage imageNamed:@"05Clock-Ev"];
    early_evening.marker = [UIImage imageNamed:@"05marker"];
    early_evening.phase_name = @"evening";
    
    evening.phase_id = @"evening";
    evening.light_color = [UIColor whiteColor];
    evening.dark_color = [UIColor colorWithRed:99/255.0 green:118/255.0 blue:164/255.0 alpha:0.7];
    evening.route_color = [UIColor blackColor];
    evening.clock = [UIImage imageNamed:@"06Clock-Ngt"];
    evening.marker = [UIImage imageNamed:@"06marker"];
    evening.phase_name = @"night";
    
    NSArray *phases = [[NSArray alloc] initWithObjects:menu,early_morning,morning,mid_day,afternoon,early_evening,evening, nil];
    
    return phases;
}

@end
