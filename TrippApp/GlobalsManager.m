//
//  GlobalsManager.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-18.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "GlobalsManager.h"

@implementation GlobalsManager

+ (GlobalsManager *)sharedInstance
{
    // the instance of this class is stored here
    static GlobalsManager *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}

@end
