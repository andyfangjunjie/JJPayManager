//
//  AppDelegate.m
//  JJPayManagerDemo
//
//  Created by 房俊杰 on 2017/8/24.
//  Copyright © 2017年 房俊杰. All rights reserved.
//

#import "AppDelegate.h"
#import "JJPayManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //注册微信
    [[JJPayManager sharedManager] registerApp:@""];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // 其他如支付等SDK的回调
    return [[JJPayManager sharedManager] handleOpen:url delegate:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // 其他如支付等SDK的回调
    return [[JJPayManager sharedManager] handleOpen:url delegate:nil];
}


@end
