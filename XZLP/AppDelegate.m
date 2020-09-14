//
//  AppDelegate.m
//  XZLP
//
//  Created by anson on 2020/9/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import "AppDelegate.h"
#import "XZLaunchViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    XZLaunchViewController *vc = [XZLaunchViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
