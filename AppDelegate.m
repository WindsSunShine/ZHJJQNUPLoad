//
//  AppDelegate.m
//  ZHJJQNUPLoad
//
//  Created by 张建军 on 16/10/18.
//  Copyright © 2016年 张建军. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHJJQNUploadManager.h"
// 存放资源的空间的名字【文件夹的名字】
static NSString *QiNiuScope = @"windssunshine";
// 在个人面板-->个人中心-->密钥管理 即可查看
static NSString *QiNiuAccessKey = @"gcn7xm8B40NPvcH5ajv0L3miPhp5biS_PF1IoMFE";
static NSString *QiNiuSecretKey = @"B-2VHKHhHf9Ot3YfkSXN8IMZZhtz4SFx4Lr6Rusv";
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 注册token
    
    [self registerQiNiuToken];

    
    return YES;
}
- (void)registerQiNiuToken {
    [[ZHJJQNUploadManager sharedInstance] registerWithScope:QiNiuScope
                                                   accessKey:QiNiuAccessKey
                                                   secretKey:QiNiuSecretKey];
    [[ZHJJQNUploadManager sharedInstance] createToken];
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
