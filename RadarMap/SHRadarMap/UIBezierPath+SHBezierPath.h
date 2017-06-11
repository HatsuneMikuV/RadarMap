//
//  UIBezierPath+SHBezierPath.h
//  RadarMap
//
//  Created by angle on 2017/6/9.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (SHBezierPath)

/**
 计算雷达最底层路线或者等分值雷达路线

 @param center 视图中心
 @param length 半径
 @return 路线
 */
+ (CGPathRef)drawPentagonWithCenter:(CGPoint)center Length:(double)length;


/**
 计算数组分值半径雷达路线

 @param center 视图中心
 @param lengths 数组分值半径
 @return 路线
 */
+ (CGPathRef)drawPentagonWithCenter:(CGPoint)center LengthArray:(NSArray *)lengths;


/**
 计算数组分值半径所对应的位置数组

 @param lengthArray 数组分值半径
 @param center 视图中心
 @return 路线
 */
+ (NSArray *)converCoordinateFromLength:(NSArray *)lengthArray Center:(CGPoint)center;

@end
