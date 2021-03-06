//
//  AppDelegate.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 12/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "AppDelegate.h"
#import "FESearchViewController.h"
#import "FEFlickrAPIDataProvider.h"
#import "FEUITheme.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
-(void) setUITheme{
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor: [FEUITheme primaryColorDark]];
    [[UINavigationBar appearance] setBarTintColor:[FEUITheme primaryColorLight]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[FEUITheme primaryColorDark]}];
}

-(UIViewController*) demoHome{
    //For now the first thing user see is the Search Page under a navigation controller
    FESearchViewController *searchVC = [FESearchViewController viewControllerWithDataProvider:[FEFlickrAPIDataProvider sharedDefaultProvider]
                                                                                imageProvider:[FEFlickrAPIDataProvider sharedDefaultProvider]];
    return [[UINavigationController alloc] initWithRootViewController:searchVC];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setUITheme];
    
    self.window = [UIWindow new];
    
    //set home page for this code demo
    [self.window setRootViewController:[self demoHome]];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
