//
//  SHRadarMapView.h
//  RadarMap
//
//  Created by angle on 2017/6/9.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+HexString.h"


typedef NS_OPTIONS(NSInteger, SHRadarMapViewType) {
    SHRadarMapViewTypeNone = 0,    //默认分值不显示
    SHRadarMapViewTypeTitleScore , //单一名称下显示单一分值
    SHRadarMapViewTypeTitle ,      //显示总分值
    SHRadarMapViewTypeScore ,      //显示总分值和单一分值
};



@class SHRadarMapView;

@protocol SHRadarMapViewDelegate <NSObject>

- (void)SHRadarMapView:(SHRadarMapView *)radarView;

@end



@interface SHRadarMapView : UIView
//底层颜色
@property (nonatomic, strong) UIColor *bottomColor;
//五角文字颜色
@property (nonatomic, strong) UIColor *titlesColor;
//总均分值颜色
@property (nonatomic, strong) UIColor *scoreColor;
//五角分值颜色
@property (nonatomic, strong) UIColor *titleScoreColor;
//五角文字大小
@property (nonatomic, strong) UIFont *titleFont;
//总均分描边颜色
@property (nonatomic, strong) UIColor *scoreStrokeColor;
//总均分描边宽度
@property (nonatomic, assign) CGFloat scoreStrokeWidth;
//总均分值字体大小
@property (nonatomic, strong) UIFont *scoreFont;
//五角点的颜色
@property (nonatomic, strong) UIColor *dotColor;
//五角点的半径
@property (nonatomic, assign) CGFloat dotRadius;
//中心线的颜色
@property (nonatomic, strong) UIColor *lineColor;
//中心线的宽度
@property (nonatomic, assign) CGFloat lineWidth;
//雷达图的描边颜色 可给nil
@property (nonatomic, strong) UIColor *strokeColor;
//雷达图基本图层数
@property (nonatomic, assign) NSInteger layerNum;

@property (nonatomic, weak)id<SHRadarMapViewDelegate>delegate;


/**
 设置单一色层雷达图
 
 @param scores 分值数组
 */
- (void)setScoreArray:(NSArray<NSNumber *> *)scores withColor:(UIColor *)color strokeColor:(UIColor *)strokeColor;

/**
 设置多色层雷达图（colors.count）

 @param scores 分值数组
 @param colors 多层颜色
 */
- (void)setScoreArray:(NSArray<NSNumber *> *)scores withColors:(NSArray<UIColor *> *)colors strokeColors:(NSArray<UIColor *> *)strokeColors;

/**
 绘制单一底层基本雷达图

 @param frame frame
 @param radius 半径
 @param titles 五角名称
 @param bigScore 最大分值
 @param type SHRadarMapViewType
 @return 雷达图
 */
+ (SHRadarMapView *)radarMapView:(CGRect)frame radius:(CGFloat)radius titles:(NSArray<NSString *> *)titles bigScore:(double)bigScore type:(SHRadarMapViewType)type;

@end


@interface GLLableStroke : UILabel

//描边宽度
@property (nonatomic, assign) CGFloat strokeWidth;

@end
