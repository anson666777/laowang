//
//  BaseBriefView.m
//  XGameLover
//
//  Created by bifen on 2020/7/7.
//  Copyright © 2020 sport. All rights reserved.
//

#import "BaseBriefView.h"
#import "Macros.h"
#import <Masonry/Masonry.h>

@interface BaseBriefView ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation BaseBriefView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
    }
    
    return self;
}

- (void)showView {
    self.backgroundColor = MainColor;
    
    self.imgView = [UIImageView new];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.layer.cornerRadius = 6;
    [self addSubview:self.imgView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.mas_offset(180);
    }];
    
    self.textView = [UITextView new];
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.editable = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textView];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(200);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.bottom.equalTo(self).offset(0);
    }];
}

- (void)setShowDict:(NSDictionary *)showDict {
    _showDict = showDict;
    self.imgView.image = [UIImage imageNamed:[showDict objectForKey:@"img"]];
    self.textView.text = [showDict objectForKey:@"content"];
}

@end
