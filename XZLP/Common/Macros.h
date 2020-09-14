//
//  Macros.h
//  SAJControl
//
//  Created by user on 2017/8/1.
//  Copyright © 2017年 SAJDev. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define WindowWidth      [UIScreen mainScreen].bounds.size.width

#define WindowHeight     [UIScreen mainScreen].bounds.size.height

#define MainColor RGB(17,114,198)

#define RGB(R, G, B)     [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 宽度比例适配
#define XM_SCALE(value)     ceil(1.0 * (value) * WindowWidth / 375.0)

#endif /* Macros_h */
