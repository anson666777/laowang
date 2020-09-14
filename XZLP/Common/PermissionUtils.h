//
//  PermissionUtils.h
//  XMSport
//
//  Created by bifen on 2020/7/24.
//  Copyright © 2020 XMSport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermissionUtils : NSObject

/// 获取相机权限
+ (BOOL)isAppHasCameraPermission;

/// 获取相册权限，iOS11以上默认有相册权限，因此暂时没人说要加这权限判断，先把方法写了放在这
+ (void)isCanVisitPhotoLibrary:(void(^)(BOOL))result;

@end

NS_ASSUME_NONNULL_END
