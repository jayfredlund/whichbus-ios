//
//  WBAppDelegate.m
//  Which Bus
//
//  Created by Joe Schulman on 1/19/13.
//  Copyright (c) 2013 Which Bus, LLC. All rights reserved.
//

#import "WBAppDelegate.h"
#import <MapKit/MKDirectionsRequest.h>
#import "WBViewController.h"

@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Received openURL rqeuest");
    if([MKDirectionsRequest isDirectionsRequestURL:url] == YES)
    {
        MKDirectionsRequest* directionRequest = [[MKDirectionsRequest alloc]initWithContentsOfURL: url];
        CLLocation* srcLoc = directionRequest.source.placemark.location;
        CLLocation* dstLoc = directionRequest.destination.placemark.location;
        WBViewController* rootController = (WBViewController*)[[self window] rootViewController];
        
        // need to filter bad GPS data -- 0.0 means current location
        if(srcLoc.coordinate.latitude == 0)
        {
            [rootController getDirectionsFromHereTo:dstLoc];
        }
        else if(dstLoc.coordinate.latitude == 0)
        {
            [rootController getDirectionsToHereFrom:srcLoc];
        }
        else
        {
            [rootController getDirectionsFrom:srcLoc To:dstLoc];
        }
        return YES;
    }
    else
    {
        return NO;
        NSLog(@"Ignoring non-routing url request");
    }
}

@end
