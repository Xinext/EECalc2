//
//  AppDelegate.m
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/03/06.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import "AppDelegate.h"
#import "DecimalViewController.h"
#import "HexdecimalViewController.h"
#import "FreqViewController.h"
#import "BitLengthViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.

	// UIWindowの初期化
	self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
	
	// Decimal View
	DecimalViewController *viewController1 = [[DecimalViewController alloc]init];
	
	// Hex View
	HexdecimalViewController *viewController2 = [[HexdecimalViewController alloc]init];
	
	// Freq view
	FreqViewController *viewController3 = [[FreqViewController alloc]init];
	
	// Bit Length view
	BitLengthViewController *viewController4 = [[BitLengthViewController alloc]init];
	
	NSArray *array = [NSArray arrayWithObjects:
					  viewController1,
					  viewController2,
					  viewController3,
					  viewController4,
					  nil];
	
	// Tab Bar Controllerの初期化
	UITabBarController *tabBarController = [[UITabBarController alloc]init];
	[tabBarController setViewControllers:array];
	
	// Windowへルートを設定する
	self.window.rootViewController = tabBarController;
	
	// Windowの作成と表示
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
