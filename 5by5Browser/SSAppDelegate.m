//
//  SSAppDelegate.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSMasterViewController.h"
#import "SSDetailViewController.h"
#import "ShowViewController.h"
#import "FiveByFive.h"
#import "Show.h"

@implementation SSAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    FiveByFive *fiveByFive = [[FiveByFive alloc] initWithBaseURL: @"http:/feeds.feedburner.com/"];
    [fiveByFive addShow: [Show showWithName: @"After Dark"         feedPath: @"5by5-afterdark"  webPath: @"afterdark"]];
    [fiveByFive addShow: [Show showWithName: @"Amplified"          feedPath: @"5by5-amplified"  webPath: @"amplified"]];
    [fiveByFive addShow: [Show showWithName: @"Back to Work"       feedPath: @"back2work"       webPath: @"b2w"]];
    [fiveByFive addShow: [Show showWithName: @"Build and Analyze"  feedPath: @"buildanalyze"    webPath: @"buildanalyze"]];
    [fiveByFive addShow: [Show showWithName: @"The B&B Podcast"    feedPath: @"thebbpodcast"    webPath: @"bb"]];
    [fiveByFive addShow: [Show showWithName: @"The Critical Path"  feedPath: @"criticalpath"    webPath: @"criticalpath"]];
    [fiveByFive addShow: [Show showWithName: @"Geek Friday"        feedPath: @"GeekFriday"      webPath: @"geekfriday"]];
    [fiveByFive addShow: [Show showWithName: @"Hypercritical"      feedPath: @"hypercritical"   webPath: @"hypercritical"]];
    [fiveByFive addShow: [Show showWithName: @"The Talk Show"      feedPath: @"thetalkshow"     webPath: @"talkshow"]];
    [fiveByFive addShow: [Show showWithName: @"5by5 Specials"      feedPath: @"5by5-specials"   webPath: @"specials"]];
    [fiveByFive addShow: [Show showWithName: @"5by5 at the Movies" feedPath: @"5by5AtTheMovies" webPath: @"movies"]];

    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        SSMasterViewController *masterViewController = [[SSMasterViewController alloc] initWithNibName:@"SSMasterViewController_iPhone" bundle:nil];
        ShowViewController *showViewController = [[ShowViewController alloc] initWithNibName: @"ShowViewController_iPhone" bundle: nil];
        SSDetailViewController *detailViewController = [[SSDetailViewController alloc] initWithNibName:@"SSDetailViewController_iPhone" bundle:nil];
        
        masterViewController.fiveByFive = fiveByFive;
        masterViewController.showViewController = showViewController;
        showViewController.detailViewController = detailViewController;
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        [self.navigationController.navigationBar setTintColor: [UIColor colorWithWhite: 0.3 alpha: 1.0]];
        self.window.rootViewController = self.navigationController;
    } else {
        SSMasterViewController *masterViewController = [[SSMasterViewController alloc] initWithNibName:@"SSMasterViewController_iPad" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        [masterNavigationController.navigationBar setTintColor: [UIColor colorWithWhite: 0.3 alpha: 1.0]];

        ShowViewController *showViewController = [[ShowViewController alloc] initWithNibName: @"ShowViewController_iPad" bundle: nil];

        SSDetailViewController *detailViewController = [[SSDetailViewController alloc] initWithNibName:@"SSDetailViewController_iPad" bundle:nil];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        [detailNavigationController.navigationBar setTintColor: [UIColor colorWithWhite: 0.3 alpha: 1.0]];

        masterViewController.fiveByFive = fiveByFive;
        masterViewController.showViewController = showViewController;
        showViewController.detailViewController = detailViewController;
        [detailNavigationController setNavigationBarHidden: YES];

        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = detailViewController;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];

        self.window.rootViewController = self.splitViewController;
    }
    [self.window makeKeyAndVisible];
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
    SSMasterViewController *masterViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        masterViewController = [[self.navigationController viewControllers] objectAtIndex: 0];
    }
    else {
        masterViewController = [[[[self.splitViewController viewControllers] objectAtIndex: 0] viewControllers] objectAtIndex: 0];
    }
    [masterViewController checkNowPlaying];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
