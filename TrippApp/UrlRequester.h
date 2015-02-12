//
//  UrlRequester.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-22.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlRequester : NSObject

+ (void) GetJsonObjectsFrom:(NSString*)url WithCallback:(SEL)selector FromSource:(id)sourceClass;

@end