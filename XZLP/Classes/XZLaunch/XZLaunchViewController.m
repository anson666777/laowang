//
//  XZLaunchViewController.m
//  西藏纪录游
//
//  Created by anson on 2020/9/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import "XZLaunchViewController.h"
#import <Masonry/Masonry.h>
#import "Macros.h"
#import "XZMainViewController.h"
#import "XZNavigationController.h"
#import "PermissionUtils.h"

@interface XZLaunchViewController ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation XZLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews {
    self.bgView = [UIView new];
    self.bgView.backgroundColor = MainColor;
    [self.view addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"旅   拍   西   藏";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:30];
    [self.bgView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(200);
        make.left.right.equalTo(self.bgView).offset(0);
    }];

    //副标题
    UILabel *subTitleLab = [UILabel new];
    subTitleLab.text = @"把西藏的风景\n留在心中";
    subTitleLab.numberOfLines = 0;
    subTitleLab.textColor = [UIColor whiteColor];
    subTitleLab.textAlignment = NSTextAlignmentCenter;
    subTitleLab.font = [UIFont fontWithName:@"AmericanTypewriter" size:15];
    [self.bgView addSubview:subTitleLab];

    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.bgView).offset(0);
        make.right.equalTo(self.bgView).offset(0);
    }];

    CGFloat width = (WindowWidth - 50*2 - 10*2)/3;

    for (int i = 0; i < 3; i ++) {
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.backgroundColor = [UIColor orangeColor];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%ld",(long)i+1]];
        imgView.layer.masksToBounds = YES;
        imgView.layer.borderColor = [UIColor whiteColor].CGColor;
        imgView.tag = 10000 + i;
        imgView.layer.borderWidth = 3;
        [self.bgView addSubview:imgView];

        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(380 + i/3*(width + 10));
            make.left.equalTo(self.bgView).offset(50 + i%3*(width + 10));
            make.width.height.mas_offset(width);
        }];
    }
    
    UIImageView *imgView = [self.view viewWithTag:10000];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 55/2;
    button.layer.borderWidth = 3;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"旅   拍   Action" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (imgView.mas_bottom).offset(80);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.mas_offset(55);
    }];
}

- (void)clickButton:(UIButton *)sender {
    if ([PermissionUtils isAppHasCameraPermission]) {
        XZMainViewController *vc = [XZMainViewController new];
        XZNavigationController *navi = [[XZNavigationController alloc] initWithRootViewController:vc];
        [UIApplication sharedApplication].keyWindow.rootViewController = navi;
    }
}


@end
