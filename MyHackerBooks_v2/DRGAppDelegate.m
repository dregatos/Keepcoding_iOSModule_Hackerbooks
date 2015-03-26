//
//  AppDelegate.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGAppDelegate.h"
#import "DRGLibrary.h"
#import "DRGDownloadManager.h"
#import "DRGPersistanceManager.h"

@interface DRGAppDelegate ()

@end

NSString * const WAS_LAUNCHED_BEFORE = @"WAS_LAUNCHED_BEFORE";

@implementation DRGAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Download OR Load the library
    // NOTE: Library must be downloaded ONLY during the first launch ***
    DRGLibrary *library;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:WAS_LAUNCHED_BEFORE]) {
        NSLog(@"Loading library...");
        library = [DRGPersistanceManager loadLibraryFromDocumentFolder];
    }
    
    if (!library) { // If the library wasn't loaded OR we weren't able to load it, then download it.
        NSLog(@"Downloading library...");
        library = [DRGDownloadManager downloadLibraryFromServer];
        // Save library
        [DRGPersistanceManager saveLibraryOnDocumentFolder:library];
        // Download&Save books' resources
        [DRGPersistanceManager saveResourcesOfLibrary:library];
        // Update 'WAS_LAUNCHED_BEFORE' flag value
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WAS_LAUNCHED_BEFORE];
    }
    
    NSLog(@"Library description\n%@", [library description]);
    
    
    
    
    
    
    
    
    
    
    
    
    [self.window makeKeyAndVisible];
    
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

@end
