//
//  XZDetailViewController.h
//  XZLP
//
//  Created by anson on 2020/9/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import "XZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZDetailViewController : XZBaseViewController

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *picName;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
