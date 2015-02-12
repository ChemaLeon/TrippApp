//
//  UrlRequester.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-22.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "UrlRequester.h"

@implementation UrlRequester

+ (void) GetJsonObjectsFrom:(NSString*)url WithCallback:(SEL)selector FromSource:(id)sourceClass {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error || jsonArray == nil) {
            NSLog(@"Error parsing JSON.");
        }
        else {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [sourceClass performSelector:selector withObject:jsonArray];
            #pragma clang diagnostic pop
        }
        
    });
}

@end
