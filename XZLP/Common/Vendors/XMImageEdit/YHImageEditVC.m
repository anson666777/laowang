//
//  YHImageEditVC.m
//  YHImageCropDemo
//
//  Created by 张长弓 on 2018/1/18.
//  Copyright © 2018年 张长弓. All rights reserved.
//

#import "YHImageEditVC.h"
#import "YHCropView.h"
#import "Macros.h"
#import <Masonry/Masonry.h>

//#import "XMSportDefines.h"

@interface YHImageEditVC ()<YHDCropViewDelegate>

@property (nonatomic, weak) id <YHDPhotoEditVCDelegate>delegate;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) YHCropView *cropView;
@property (nonatomic ,strong)UIButton *cancelBtn;
@property (nonatomic ,strong)UIButton *selectBtn;

@end

@implementation YHImageEditVC

- (instancetype)initWithImage:(UIImage *)aImage delegate:(id<YHDPhotoEditVCDelegate>)aDelegate {
    self = [super init];
    if (self) {
        _image = aImage;
        _delegate = aDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = [UIColor blackColor];

//    self.title = @"图片裁剪";
//    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"选取" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
//    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    // 编辑处 view
    self.cropView = [[YHCropView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.cropView.delegate = self;
    [self.view addSubview:self.cropView];
    
    self.cropView.image = self.image;
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.selectBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(XM_SCALE(16));
        make.top.mas_equalTo(XM_SCALE(62));
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(XM_SCALE(-16));
        make.top.mas_equalTo(XM_SCALE(62));
    }];
}
- (void)selectBtnClick{
     [self dismissCurrentViewController];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(yhdOptionalPhotoEditVC:didFinishCroppingImage:)]) {
        [self.delegate yhdOptionalPhotoEditVC:self didFinishCroppingImage:self.cropView.croppedImage];
    }
}
- (void)cancelBtnClick{
    [self dismissCurrentViewController];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(yhdOptionalPhotoEditVC:didFinishCroppingImage:)]) {
        [self.delegate yhdOptionalPhotoEditVC:self didFinishCroppingImage:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    // 开启返回手势
//    self.fd_interactivePopDisabled = NO;
}

#pragma mark - Click Events
- (void)leftBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(id)sender {
    
}

- (void)dismissCurrentViewController {
    if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Delegates

- (void)mmtdOptionalDidBeginingTailor:(YHCropView *)cropView {
//    [self showHUDWithText:@"请稍候..."];
}

- (void)mmtdOptionalDidFinishTailor:(YHCropView *)cropView {
//    [self hideHUD];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setTitle:@"选取" forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_selectBtn setTitleColor:RGB(203, 154, 102) forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
