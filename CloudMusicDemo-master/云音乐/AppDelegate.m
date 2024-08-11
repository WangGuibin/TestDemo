//
//  AppDelegate.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "AppDelegate.h"
#import "MLViewController.h"
#import "SFViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    //初始化控制器
    MLViewController *mlvc = [[MLViewController alloc]init];
    SFViewController *sfvc = [[SFViewController alloc]init];
    //初始化抽屉控制器
    MMDrawerController *drawerC = [[MMDrawerController alloc]initWithCenterViewController:mlvc leftDrawerViewController:sfvc];
    //打开抽屉的手势
    drawerC.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    //关闭抽屉的手势
    drawerC.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    //设置左边展开为屏幕的75%
    drawerC.maximumLeftDrawerWidth = self.window.frame.size.width*0.75;
    self.window.rootViewController = drawerC;
    return YES;
}

//openURL:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return YES;
}

//handleOpenURL:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
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
