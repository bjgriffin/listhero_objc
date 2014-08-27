//
//  AppDelegate.m
//  CalendarDraw
//
//  Created by BJ Griffin on 3/2/14.
//  Copyright (c) 2014 BJ Griffin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        UISplitViewController *splitViewController = [storyboard instantiateInitialViewController];
        
        UINavigationController *navController = [splitViewController.viewControllers objectAtIndex:0];
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        self.favoritesViewController = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
        self.favoritesViewController.title = @"Favorites";
        self.favoritesViewController.tabBarItem.image = [UIImage imageNamed:@"star-icon-favorited.png"];
        self.favoritesViewController.tabBarItem.title = @"Favorites";
        self.drawerViewController = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
        self.drawerViewController.tabBarItem.image = [UIImage imageNamed:@"pencil-icon-tab.png"];
        self.drawerViewController.title = @"Lists";
        NSArray *array = [[NSArray alloc] initWithObjects:self.drawerViewController, self.favoritesViewController, nil];
        tabBarController.viewControllers = array;
        [navController pushViewController:tabBarController animated:NO];
        
        self.shoppingListViewController = [splitViewController.viewControllers objectAtIndex:1];
        splitViewController.delegate = self.shoppingListViewController;
        self.window.rootViewController = splitViewController;
    }
    else
    {
        self.containerViewController = [[ContainerViewController alloc] initWithNibName:@"ContainerViewController" bundle:nil];
        
        [self.window setRootViewController:self.containerViewController];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}

- (void)setUserDefaultCurrentList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [defaults setObject:[self.shoppingListViewController.currentList objectID].URIRepresentation.absoluteString forKey:@"lastListURI"];
    } else {
        [defaults setObject:[self.containerViewController.shoppingListViewController.currentList objectID].URIRepresentation.absoluteString forKey:@"lastListURI"];
    }
    
    [defaults synchronize];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self setUserDefaultCurrentList];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, exception);
}

@end
