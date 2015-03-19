//
//  DateHelper.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-20.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

NSString *serverDateFormat = @"yyyy-MM-dd HH:mm:ss";
NSString *showDateFormat = @"MM/dd/yyyy";

+ (NSDate*)convertStrToDate:(NSString *)stringDate
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:serverDateFormat];
    NSDate *date = [dateFormat dateFromString:stringDate];
    return date;
}

+ (NSString*)convertDateToStr:(NSDate *)date
{
    // Convert date to string object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:serverDateFormat];
    NSString *stringDate = [dateFormat stringFromDate:date];
    return stringDate;
}

+ (NSString*)formatStrDatetoShow:(NSString *)date
{
    // Convert date to string object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:showDateFormat];
    NSString *stringDate = [dateFormat stringFromDate: [DateHelper convertStrToDate:date]];
    return stringDate;
}



+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
