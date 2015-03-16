//
//  DateHelper.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-20.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSDate*) convertStrToDate: (NSString*)stringDate;
+ (NSString*)convertDateToStr:(NSDate *)date;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end
