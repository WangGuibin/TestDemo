//
//  AppDelegate.m
//  TestDemo
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "VCTimeProfiler.h"
#import "XDAppFluencyMonitor.h"
#import "TBCityIconFont.h"
#import "WGBTopWindow.h"
#import "ViewController.h"
#import "PAirSandbox.h"
#import "Felix.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self testFixOnLineBug];

    // Override point for customization after application launch.
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[WGBCustomNavgationViewController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];

    
    // 添加一个window, 点击这个window, 可以让屏幕上的scrollView滚到最顶部
    [WGBTopWindow show];
    //调试插件 UI热重载
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    //页面耗时统计
//    [[VCTimeProfiler shared] start];
//    [[XDAppFluencyMonitor sharedInstance] startMonitoring];
//    RegisterTenderCrashHandler();
    //iconfont 资源初始化
    [TBCityIconFont setFontName:@"iconfont"];
    [[PAirSandbox sharedInstance] enableSwipe];
    return YES;
}


- (void)testFixOnLineBug{
    [Felix fixIt];
    NSString *fixScriptString = @" \
    fixInstanceMethodReplace('ViewController', 'testCrash:', function(instance, originInvocation, originArguments){ \
        if (originArguments[0].length == 0) { \
            console.log('数组越界了,但被我修复了'); \
        } else { \
            runInvocation(originInvocation); \
        } \
    }); \
    \
    ";
    
    //通过服务端下发js 修复bug 只能加一些简单的替换逻辑(基于Aspects)
    [Felix evalString:fixScriptString];
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
