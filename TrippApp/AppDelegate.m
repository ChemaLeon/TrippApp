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

//Color Definition
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()

@end


NSString *const newUserService = @"newUserService";
NSString *const getCitiesService = @"getCitiesService";
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
    
    [APIServiceManager getCitieswithObserver:getCitiesService];
    
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x2E9ACA)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //NSShadow *shadow = [[NSShadow alloc] init];
    //shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    //shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Futura" size:21.0], NSFontAttributeName, nil]];
    
    // Add this if you only want to change Selected Image color
    // and/or selected image text
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    // Add this code to change StateNormal text Color,
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateNormal];
    
    // then if StateSelected should be different, you should add this code
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateSelected];

    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCitiesNotification:) name:getCitiesService object:nil];
    
}

-(void) receivedUserKeyNotification:(NSNotification*) notification
{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        _userKey = [theData objectForKey:@"userKey"];
        [self saveData];
    }
    
}

-(void) receivedCitiesNotification:(NSNotification*) notification
{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        [GlobalsManager sharedInstance].cities = [[NSArray alloc] initWithArray:(NSMutableArray*)[theData objectForKey:@"cities"]];
    }
    
}



@end
