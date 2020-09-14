//
//  UIViewController+XMAdd.h
//  XMSportDevelop
//
//  Created by fly on 04/08/2019.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XMAdd)

/// 获取当前显示的ViewController
+ (UIViewController*)xm_topViewController;

/// 获取VC当前NavigationController
- (UINavigationController *)xm_currentNaviController;

/// 以全屏方式Present一个VC
/// @param vc 待显示VC
- (void)xm_presentFullScreenVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
