//
//  AppDelegate.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//
#import "AppDelegate.h"
#import "APIServiceManager.h"
#import "GlobalsManager.h"

@interface AppDelegate ()

@end

NSString *const newUserService = @"newUserService";
//NSString *const mapsKey = @"AIzaSyCyKpAQW_zR9t2XEjTGrXP9QDKEWKnMF4E";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initializeNotifications];

    //[GlobalsManager sharedInstance].mapsKey = mapsKey;
    //[GMSServices provideAPIKey:[[GlobalsManager sharedInstance] mapsKey]];
    // look for saved data.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([savedData objectForKey:@"userKey"] != nil) {
            _userKey = [savedData objectForKey:@"userKey"];
            [GlobalsManager sharedInstance].userKey = _userKey;
        }
    }
    else
    {
        [APIServiceManager createNewUser:newUserService];
        [GlobalsManager sharedInstance].userKey = _userKey;
        
    }
    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark UserAPIKeyFunctions

- (void) saveData {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (_userKey != nil) {
        [dataDict setObject:_userKey forKey:@"userKey"];  // save the games array
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
}

- (void) initializeNotifications{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedUserKeyNotification:) name:newUserService object:nil];
    
}

-(void) receivedUserKeyNotification:(NSNotification*) notification
{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        _userKey = [theData objectForKey:@"userKey"];
        [self saveData];
    }
    
}



@end
