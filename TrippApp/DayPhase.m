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
    menu.light_color = [UIColor whiteColor];
    menu.dark_color = [UIColor whiteColor];

    early_morning.phase_id = @"early_morning";
    early_morning.light_color = [UIColor whiteColor];
    early_morning.dark_color = [UIColor colorWithRed:254/255.0 green:229/255.0 blue:156/255.0 alpha:0.1];
    early_morning.route_color = [UIColor colorWithRed:254/255.0 green:229/255.0 blue:156/255.0 alpha:1];

    morning.phase_id = @"morning";
    morning.light_color = [UIColor whiteColor];
    morning.dark_color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:82/255.0 alpha:0.1];
    morning.route_color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:82/255.0 alpha:1];

    mid_day.phase_id = @"mid_day";
    mid_day.light_color = [UIColor whiteColor];
    mid_day.dark_color = [UIColor colorWithRed:254/255.0 green:207/255.0 blue:56/255.0 alpha:0.1];
    mid_day.route_color = [UIColor colorWithRed:254/255.0 green:207/255.0 blue:56/255.0 alpha:1];
    
    afternoon.phase_id = @"afternoon";
    afternoon.light_color = [UIColor whiteColor];
    afternoon.dark_color = [UIColor colorWithRed:39/255.0 green:151/255.0 blue:209/255.0 alpha:0.1];
    afternoon.route_color = [UIColor colorWithRed:39/255.0 green:151/255.0 blue:209/255.0 alpha:1];
    
    early_evening.phase_id = @"early_evening";
    early_evening.light_color = [UIColor whiteColor];
    early_evening.dark_color = [UIColor colorWithRed:20/255.0 green:53/255.0 blue:107/255.0 alpha:0.1];
    early_evening.route_color = [UIColor colorWithRed:20/255.0 green:53/255.0 blue:107/255.0 alpha:1];
    
    evening.phase_id = @"evening";
    evening.light_color = [UIColor whiteColor];
    evening.dark_color = [UIColor colorWithRed:21/255.0 green:22/255.0 blue:57/255.0 alpha:0.1];
    evening.route_color = [UIColor colorWithRed:21/255.0 green:22/255.0 blue:57/255.0 alpha:1];
    
    NSArray *phases = [[NSArray alloc] initWithObjects:menu,early_morning,morning,mid_day,afternoon,early_evening,evening, nil];
    
    return phases;
}

@end
