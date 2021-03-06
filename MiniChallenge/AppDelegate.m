//
//  AppDelegate.m
//  MiniChallenge
//
//  Created by Esdras Martins on 13/03/14.
//  Copyright (c) 2014 Esdras Martins. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    NSString* dateKey = @"dateKey";
    NSDate* lastRead = (NSDate*)[[NSUserDefaults standardUserDefaults]objectForKey:dateKey];
    if (lastRead == nil) {
        
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        
        // do any other initialization you want to do here - e.g. the starting default values.
        // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_sounds"];
        [[NSUserDefaults standardUserDefaults]setFloat:0 forKey:@"recordLocal"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mutado"];
        
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    
    if ([UIDevice.currentDevice.systemVersion floatValue] >= 8.0)
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings* mySettings = [UIUserNotificationSettings settingsForTypes: types
                                                                                   categories: nil];
        [UIApplication.sharedApplication registerUserNotificationSettings: mySettings];
    }
    
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:76000];
    localNotification.alertBody = @"Pepe está sentindo sua falta! Venha pular com ele.";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
