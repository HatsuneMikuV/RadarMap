//
//  UIColor+HexString.h
//  RadarMap
//
//  Created by angle on 2017/6/9.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)


/**
 16进制字符串颜色值转换

 @param color 16进制字符串颜色
 @return 颜色
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
