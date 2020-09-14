//
//  XZMainTableViewCell.h
//  XZLP
//
//  Created by anson on 2020/9/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZMainTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, copy) NSString *imgName;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
