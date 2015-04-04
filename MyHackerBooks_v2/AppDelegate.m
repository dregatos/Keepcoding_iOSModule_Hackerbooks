//
//  AppDelegate.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 26/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "AppDelegate.h"

#import "Settings.h"

#import "DRGLibrary.h"
#import "DRGDownloadManager.h"
#import "DRGPersistanceManager.h"

#import "DRGBookDetailVC.h"
#import "DRGLibraryTableVC.h"

@interface AppDelegate ()

@end

NSString * const WAS_LAUNCHED_BEFORE = @"WAS_LAUNCHED_BEFORE";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Appearance
//    [self customiseAppeareance];
    
    /** First selected character for iPad */
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:LAST_SELECTED_BOOK]) {
        // Default value
        [def setObject:@[@1,@0] forKey:LAST_SELECTED_BOOK];
        // Just in case...
        [def synchronize];
    }
    
    // Get our Model ***
    DRGLibrary *library = [self getLibrary];
    NSLog(@"Library description\n%@", [library description]);
    
    /** Phone or tablet ? */
    UIViewController *rootVC = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        rootVC = [self rootViewControllerForPadWithModel:library];
    } else {
        rootVC = [self rootViewControllerForPhoneWithModel:library];
    }
    
    // Assign the root
    self.window.rootViewController = rootVC;
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

#pragma mark - Appearance

- (void)customiseAppeareance {
    
    // Window
    self.window.backgroundColor = [UIColor clearColor];
    
    // UINavigationBar ***
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.5 green:0 blue:0.13 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"AvenirNext-Bold" size:20.0], NSFontAttributeName,
                                                           nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}


#pragma mark - Helpers

- (DRGLibrary *)getLibrary {
    
    // Download OR Load the library
    // NOTE: Library must be downloaded ONLY during the first launch ***
    DRGLibrary *library;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:WAS_LAUNCHED_BEFORE]) {
        NSLog(@"Loading library...");
        library = [DRGPersistanceManager loadLibraryFromDocumentsFolder];
    }
    
    if (!library) { // If the library wasn't loaded OR we weren't able to load it, then download it.
        NSLog(@"Downloading library...");
        library = [DRGDownloadManager downloadLibraryFromServer];
        // Save library
        [DRGPersistanceManager saveLibraryOnDocumentsFolder:library];
        // Update 'WAS_LAUNCHED_BEFORE' flag value
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WAS_LAUNCHED_BEFORE];
    }
    
    return library;
}

- (UIViewController *)rootViewControllerForPhoneWithModel:(DRGLibrary *)library {
    
    // Create the controllers
    DRGLibraryTableVC *tableVC = [[DRGLibraryTableVC alloc] initWithLibrary:library style:UITableViewStyleGrouped];
    
    UINavigationController *libraryNav = [[UINavigationController alloc] initWithRootViewController:tableVC];
    
    //Delegates
    tableVC.delegate = tableVC;
    
    return libraryNav;
}

- (UIViewController *)rootViewControllerForPadWithModel:(DRGLibrary *)library {
    
    // Create the controllers
    DRGLibraryTableVC *tableVC = [[DRGLibraryTableVC alloc] initWithLibrary:library style:UITableViewStyleGrouped];
    DRGBook *lastSelectedBook = [self lastSelectedBookOfLibrary:library];
    
    DRGBookDetailVC *bookVC = [[DRGBookDetailVC alloc] initWithBook:lastSelectedBook ofLibrary:library];
    
    // Create navigators
    UINavigationController *leftController = [[UINavigationController alloc] initWithRootViewController:tableVC];
    UINavigationController *rightController = [[UINavigationController alloc] initWithRootViewController:bookVC];

    // Create the splitView
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    splitVC.viewControllers = @[leftController,rightController];
    
    // Assigning Delegates
    splitVC.delegate = bookVC;
    tableVC.delegate = bookVC;
    
    return splitVC;
}

- (DRGBook *)lastSelectedBookOfLibrary:(DRGLibrary *)library {
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSArray *coord = [settings objectForKey:LAST_SELECTED_BOOK];
    NSUInteger section = [coord[0] integerValue];
    NSUInteger row = [coord[1] integerValue];
    
    DRGBook *book;
    if (section == FAVORITE_SECTION_INDEX) {
        book = [[library favoriteBookList] objectAtIndex:row];
    } else {
        NSString *tag = [[library tags] objectAtIndex:section-1];
        book = [library bookForTag:tag atIndex:row];
    }
    return book;
}



@end
