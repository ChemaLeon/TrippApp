//
//  GlobalsManager.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-18.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalsManager : NSObject

@property (strong, nonatomic) NSString *userKey;

@property (strong, nonatomic) NSString *mapsKey;

+ (GlobalsManager *)sharedInstance;

@end
