//
//  XZDetailViewController.m
//  XZLP
//
//  Created by anson on 2020/9/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import "XZDetailViewController.h"
#import "Macros.h"
#import "BaseBriefView.h"
#import <Masonry/Masonry.h>
#import "YHPhotoSelect.h"
#import "PermissionUtils.h"
#import "SVProgressHUD.h"

@interface XZDetailViewController ()<YHDPhotoSelectDelegate>

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) YHPhotoSelect *photoSelect;

@property (nonatomic, strong) BaseBriefView *briefView;

@property (nonatomic, strong) NSDictionary *contentDict;

@end

@implementation XZDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainColor;
    [self setupBgView];
    [self setupNavi];
}

- (void)setupBgView {
    self.briefView = [[BaseBriefView alloc] init];
    [self.view addSubview:self.briefView];
    
    [self.briefView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.briefView showView];
    self.briefView.showDict = self.contentDict;
}

- (void)setupSubView {
    self.imgView = [UIImageView new];
    self.imgView.backgroundColor = [UIColor orangeColor];
    self.imgView.image = [UIImage imageNamed:self.picName];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.layer.masksToBounds = YES;
    [self.view addSubview:self.imgView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_offset(240);
    }];
}

- (void)setupNavi {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 21);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)rightButtonAction:(UIButton *)sender {
    if ([PermissionUtils isAppHasCameraPermission]) {
        [self.photoSelect startPhotoSelect:YHEPhotoSelectTakePhoto];
    }
}

- (YHPhotoSelect *)photoSelect {
    if (!_photoSelect) {
        _photoSelect = [[YHPhotoSelect alloc] initWithController:self delegate:self];
        _photoSelect.isAllowEdit = YES;
    }
    return _photoSelect;
}

#pragma mark - YHDPhotoSelectDelegate
- (void)yhdOptionalPhotoSelect:(YHPhotoSelect *)photoSelect didFinishedWithImageArray:(NSArray *)imageArray {
    if (imageArray.count == 0) return;
    UIImage *image = imageArray.firstObject;
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"已保存到相册!"];
}

- (NSDictionary *)contentDict {
    if (!_contentDict) {
        _contentDict = @{@"img":self.picName,@"content":self.content};
    }
    return _contentDict;
}

@end
