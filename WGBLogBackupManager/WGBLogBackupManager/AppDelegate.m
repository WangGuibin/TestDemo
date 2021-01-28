//
//  AppDelegate.m
//  WGBLogBackupManager
//
//  Created by 王贵彬 on 2021/1/28.
//

#import "AppDelegate.h"
#import "WGBLogBackupManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WGBLogBackupManager backupLog2SandBox];//备份
    return YES;
}
@end
