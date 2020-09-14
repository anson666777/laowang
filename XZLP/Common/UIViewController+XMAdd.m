//
//  UIViewController+XMAdd.m
//  XMSportDevelop
//
//  Created by fly on 04/08/2019.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import "UIViewController+XMAdd.h"

@implementation UIViewController (XMAdd)

+ (UIViewController*)xm_topViewController{
    
    UIViewController* vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

- (UINavigationController *)xm_currentNaviController {
    if(self.navigationController != nil){
        return self.navigationController;
    }
    UIViewController* vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([vc isKindOfClass:[UINavigationController class]]){
        return (UINavigationController *)vc;
    }
    if([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabVC = (UITabBarController *)vc;
        if([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]){
            return (UINavigationController *)tabVC.selectedViewController;
        }
    }
    return nil;
}

- (void)xm_presentFullScreenVC:(UIViewController *)vc {
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
}

@end
