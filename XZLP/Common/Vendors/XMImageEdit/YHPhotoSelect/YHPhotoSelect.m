//
//  YHPhotoSelect.m
//  YHImageCropDemo
//
//  Created by 张长弓 on 2018/1/18.
//  Copyright © 2018年 张长弓. All rights reserved.
//

#import "YHPhotoSelect.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YHImageEditVC.h"
#import "PermissionUtils.h"
#import "Macros.h"

@interface YHPhotoSelect ()
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
YHDPhotoEditVCDelegate
>

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, weak) id <YHDPhotoSelectDelegate> delegate;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) UIImagePickerController *pickerController;

@property (nonatomic, assign) YHEPhotoSelectType selectType;

@end

@implementation YHPhotoSelect

- (id)initWithController:(UIViewController *)viewController delegate:(id<YHDPhotoSelectDelegate>)delegate{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.delegate = delegate;
        self.imageArray = [NSMutableArray array];
    }
    return self;
}

- (void)startPhotoSelect:(YHEPhotoSelectType)type{
    switch (type) {
        case YHEPhotoSelectTakePhoto:
            [self showTakePhotoView];
            break;
        case YHEPhotoSelectFromLibrary:
            [self showPhotoSelectView];
            break;
            
        default:
            break;
    }
}

- (void)endSelect {
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)selectedImageArray {
    return self.imageArray;
}

#pragma mark - Private Methods

- (void)showTakePhotoView {
    
    if ([PermissionUtils isAppHasCameraPermission]) {
        self.selectType = YHEPhotoSelectTakePhoto;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.navigationBar.tintColor = RGB(203, 154, 102);
        self.pickerController = picker;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)showPhotoSelectView {
    
    if (!self.isMultiPickImage) {
        self.selectType = YHEPhotoSelectFromLibrary;

        // 如果不是多选, 则使用系统的控件来进行选择
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.navigationBar.tintColor = RGB(203, 154, 102);
        self.pickerController = picker;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }else{
        // 多选(暂未实现)
    }
}

- (void)selectedFinished:(NSArray *)imageArray {
    //先清空之前保存的照片列表
    [self.imageArray removeAllObjects];
    
    [self.imageArray addObjectsFromArray:imageArray];
    if ([self.delegate respondsToSelector:@selector(yhdOptionalPhotoSelect:didFinishedWithImageArray:)]) {
        [self.delegate yhdOptionalPhotoSelect:self didFinishedWithImageArray:self.imageArray];
    }
    
    if (self.imageArray.count > 0 || self.selectType == YHEPhotoSelectTakePhoto) {
        [self.pickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)selectedCancelled {
    if ([self.delegate respondsToSelector:@selector(yhdOptionalPhotoSelectDidCancelled:)]) {
        [self.delegate yhdOptionalPhotoSelectDidCancelled:self];
    }
}

#pragma mark - Delegate

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *selectedImage = nil;
    if (info[UIImagePickerControllerEditedImage]) {
        selectedImage = info[UIImagePickerControllerEditedImage];
    }else if(info[UIImagePickerControllerOriginalImage]){
        selectedImage = info[UIImagePickerControllerOriginalImage];
    }
    
    if (self.isAllowEdit) {
        YHImageEditVC *vc = [[YHImageEditVC alloc] initWithImage:selectedImage delegate:self];
        picker.view.backgroundColor = [UIColor whiteColor];
//        [picker pushViewController:vc animated:YES];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [picker presentViewController:vc animated:YES completion:nil];
    } else if (selectedImage) {
        [self selectedFinished:@[selectedImage]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    __weak YHPhotoSelect *weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf selectedCancelled];
    }];
}

#pragma mark YHDPhotoEditVCDelegate

- (void)yhdOptionalPhotoEditVC:(YHImageEditVC *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    if (croppedImage) {
        [self selectedFinished:@[croppedImage]];
    } else {
        [self selectedFinished:@[]];
    }
}

@end
