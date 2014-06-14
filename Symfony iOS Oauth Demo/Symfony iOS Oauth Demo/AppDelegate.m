//
//  AppDelegate.m
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 08-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+radio.h"
#import "DatabaseRadio.h"

@interface AppDelegate ()
      @property (strong, nonatomic) NSManagedObjectContext *DatabaseContext;

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.DatabaseContext = [self createMainQueueManagedObjectContext];
    
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

#pragma mark - Database Context

// we do some stuff when our Demo database's context becomes available
// we post a notification to let others know the context is available
- (void)setDatabaseContext:(NSManagedObjectContext *)DatabaseContext
{
    _DatabaseContext = DatabaseContext;
    
    // let everyone who might be interested know this context is available
    // this happens very early in the running of our application
    // it would make NO SENSE to listen to this radio station in a View Controller that was segued to, for example
    // (but that's okay because a segued-to View Controller would presumably be "prepared" by being given a context to work in)
    NSDictionary *userInfo = self.DatabaseContext ? @{ DatabaseAvailabilityContext : self.DatabaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:userInfo];
}

@end
