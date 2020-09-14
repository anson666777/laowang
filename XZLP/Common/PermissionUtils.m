//
//  PermissionUtils.m
//  XMSport
//
//  Created by bifen on 2020/7/24.
//  Copyright © 2020 XMSport. All rights reserved.
//

#import "PermissionUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "UIViewController+XMAdd.h"

@implementation PermissionUtils

+ (BOOL)isAppHasCameraPermission
{
    NSString *mediaType = AVMediaTypeVideo;

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"没有相机权限，请到设置里设置权限" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancel];
        [[UIViewController xm_topViewController] presentViewController:ac animated:YES completion:nil];
        
        return NO;
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        //点击弹框授权
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        }];
        return NO;
    }
    
    return YES;
}

+ (void)isCanVisitPhotoLibrary:(void(^)(BOOL))result {
    
    /// 获取当前的状态
    //+ (PHAuthorizationStatus)authorizationStatus;
    /// 请求权限
    //+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        result(YES);
        return;
    }
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        result(NO);
        return ;
    }
    
    if (status == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 回调是在子线程的
            NSLog(@"%@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status != PHAuthorizationStatusAuthorized) {
                      NSLog(@"未开启相册权限,请到设置中开启");
                      result(NO);
                      return ;
                  }
                  result(YES);
            });
  
        }];
    }
}

@end
