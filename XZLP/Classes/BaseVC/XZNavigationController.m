//
//  XZNavigationController.m
//  西藏纪录游
//
//  Created by anson on 2020/9/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import "XZNavigationController.h"
#import "Macros.h"

@interface XZNavigationController ()

@end

@implementation XZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
}

- (void)setupNavi {
    [self.navigationBar setTranslucent:NO];
     self.navigationBar.barStyle = UIBarStyleBlackOpaque;
     self.navigationBar.barTintColor = MainColor;
     self.navigationBar.tintColor = [UIColor whiteColor];
     [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
     self.navigationBar.translucent = NO;
}

@end
