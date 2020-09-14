//
//  XZLaunchViewController.h
//  西藏纪录游
//
//  Created by anson on 2020/9/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import "XZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZLaunchViewController : XZBaseViewController

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, strong) NSMutableArray *pictureArray;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) UIColor *fontColor;

@end

NS_ASSUME_NONNULL_END
