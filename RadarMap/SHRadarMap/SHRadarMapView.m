//
//  SHRadarMapView.m
//  RadarMap
//
//  Created by angle on 2017/6/9.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "SHRadarMapView.h"

#import "UIBezierPath+SHBezierPath.h"

@interface SHRadarMapView ()

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) CGPoint selfCenter;

@property (nonatomic, assign) double bigScore;

@property (nonatomic, assign) SHRadarMapViewType type;

@property (nonatomic, strong) GLLableStroke *scoreL;

@property (nonatomic, strong) NSMutableArray *layerArr;

@property (nonatomic, assign) CGFloat scoreProportion;

@property (nonatomic, strong) NSMutableArray *lableArr;

@property (nonatomic, strong) NSMutableArray *dotArr;

@property (nonatomic, strong) NSArray *scores;

@property (nonatomic, strong) UIButton *tapBtn;



@end


@implementation SHRadarMapView

#pragma mark -
#pragma mark   ==============init==============

+ (SHRadarMapView *)radarMapView:(CGRect)frame radius:(CGFloat)radius titles:(NSArray<NSString *> *)titles bigScore:(double)bigScore type:(SHRadarMapViewType)type {
    return [[self alloc] initWithFrame:frame radius:radius titles:titles bigScore:bigScore type:type more:NO];
}

- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)radius titles:(NSArray<NSString *> *)titles bigScore:(double)bigScore type:(SHRadarMapViewType)type more:(BOOL)isMore {
    if (self = [super initWithFrame:frame]) {
        
        self.titles = titles.copy;
        self.radius = radius;
        self.type = type;
        self.bigScore = bigScore == 0 ? 1:bigScore;
        
        self.titleScoreColor = [UIColor clearColor];
        self.selfCenter = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        
        self.scoreProportion = 1.0;
        
        self.layerArr = [NSMutableArray array];
        
        self.lableArr = [NSMutableArray array];
        
        self.dotArr = [NSMutableArray array];
        
        [self addSubview:self.scoreL];
        
        UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [self addGestureRecognizer:tap];

    }
    return self;
}

#pragma mark -
#pragma mark   ==============tap==============
- (void)tap:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(SHRadarMapView:)]) {
        [self.delegate SHRadarMapView:self];
    }
}
#pragma mark -
#pragma mark   ==============layoutSubviews==============
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scoreL.bounds = CGRectMake(0, 0, self.radius * 1.8, self.radius * 1.8);
    self.scoreL.center = self.selfCenter;
    
    self.scoreL.strokeWidth = self.scoreStrokeWidth;
    self.scoreL.textColor = self.scoreColor;
    self.scoreL.font = self.scoreFont;
    self.scoreL.hidden = (self.type != SHRadarMapViewTypeTitle && self.type != SHRadarMapViewTypeScore);
    
}
#pragma mark -
#pragma mark   ==============drawRect==============
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    NSArray *bigPath = [UIBezierPath converCoordinateFromLength:@[@(self.radius),@(self.radius),@(self.radius),@(self.radius),@(self.radius)] Center:self.selfCenter];
    
    for (NSValue *point in bigPath) {
        CGPoint poin = [point CGPointValue];
        
        CGContextMoveToPoint(context, self.selfCenter.x, self.selfCenter.y);
        CGContextAddLineToPoint(context, poin.x, poin.y);
    }
    
    CGContextClosePath(context);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
    [self setName:self.selfCenter andPath:bigPath];

    [self changeBgSizeFinish];
    
    [self springDotView:self.scores];
}
#pragma mark -
#pragma mark   ==============设置基本图层数+五角文字==============
- (void)setName:(CGPoint)point andPath:(NSArray *)bigPath{
    if (self.titles.count != 5 && bigPath.count != 5) {
        return;
    }
    
    if (self.layerNum == 0 || self.layerNum == 1) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        CGPathRef path = [UIBezierPath drawPentagonWithCenter:point Length:self.radius];
        layer.path = path;
        layer.fillColor = self.bottomColor.CGColor;
        layer.strokeColor = self.strokeColor.CGColor;
        [self.layer insertSublayer:layer atIndex:0];

    }else if (self.layerNum > 1) {
        for (NSInteger index = 0; index < self.layerNum; index++) {
            
            CGFloat radius = self.radius * (1 - index * 0.1/(self.layerNum * 0.1));
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            CGPathRef path = [UIBezierPath drawPentagonWithCenter:point Length:radius];
            layer.path = path;
            layer.fillColor = index == 0 ?self.bottomColor.CGColor:nil;
            layer.strokeColor = [self.strokeColor colorWithAlphaComponent:(1 - index * 0.1/(self.layerNum * 0.1))].CGColor;
            [self.layer insertSublayer:layer atIndex:(unsigned)index];
        }
    }
    
    for (int i = 0; i < 5; i ++) {
        CGPoint p = [bigPath[i] CGPointValue];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.textColor = self.titlesColor;
        lb.font = self.titleFont;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = self.titles[i];
        lb.numberOfLines = 0;
        
        NSString *title = self.titles[i];
        CGFloat width = [self getWidthWithTitle:title font:lb.font] + 10;
        CGFloat height = [self getHeightByWidth:width title:title font:lb.font] + 10;
        if (self.type == SHRadarMapViewTypeTitleScore || self.type == SHRadarMapViewTypeScore) {
            title = [NSString stringWithFormat:@"%@\n10",title];
            height = [self getHeightByWidth:width title:title font:lb.font] + 10;
        }
        lb.bounds = CGRectMake(0, 0, width, height);

        if (i == 0) {
            lb.center = CGPointMake(p.x, p.y - height * 0.5);
        }else if (i == 1) {
            lb.center = CGPointMake(p.x + width * 0.5, p.y);
        }else if (i == 2){
            lb.center = CGPointMake(p.x, p.y + height * 0.5);
        }else if (i == 3){
            lb.center = CGPointMake(p.x, p.y + height * 0.5);
        }else if (i == 4){
            lb.center = CGPointMake(p.x - width * 0.5, p.y);
        }
        [self addSubview:lb];
        [self.lableArr addObject:lb];
    }
}
//获取字体宽
- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
//获取字体高
- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

#pragma mark -
#pragma mark   ==============五角描点==============
- (void)changeBgSizeFinish {
    
    self.scoreProportion = 1.0;
    
    NSArray *array = [self convertLengthsFromScore:@[@(self.bigScore),@(self.bigScore),@(self.bigScore),@(self.bigScore),@(self.bigScore)]];
    NSArray *lengthsArray = [UIBezierPath converCoordinateFromLength:array Center:self.selfCenter];
    for (int i = 0; i < [lengthsArray count]; i++) {
        CGPoint point = [[lengthsArray objectAtIndex:i] CGPointValue];
        UIView *dotView = [[UIView alloc] init];
        dotView.backgroundColor = self.dotColor;
        dotView.center = point;
        dotView.clipsToBounds = YES;
        dotView.layer.cornerRadius = self.dotRadius;
        dotView.bounds = CGRectMake(0, 0, self.dotRadius * 2, self.dotRadius * 2);
        [self addSubview:dotView];
        [self.dotArr addObject:dotView];
    }
}
#pragma mark -
#pragma mark   ==============分数转换==============
- (NSNumber *)convertLengthFromScore:(double)score {
    score = self.scoreProportion * score;
    
    if (score >= self.bigScore) {
        return @(self.radius);
    }else if (score > 0) {
        return @(self.radius * score / self.bigScore);
    } else {
        return @(0);
    }
}
#pragma mark -
#pragma mark   ==============根据分值计算每个点的半径==============
- (NSArray *)convertLengthsFromScore:(NSArray *)scoreArray {
    NSMutableArray *lengthArray = [NSMutableArray array];
    for (int i = 0; i < [scoreArray count]; i++) {
        double score = [[scoreArray objectAtIndex:i] doubleValue];
        [lengthArray addObject:[self convertLengthFromScore:score]];
    }
    return lengthArray;
}
#pragma mark -
#pragma mark   ============设置单一色层雷达图================
- (void)setScoreArray:(NSArray<NSNumber *> *)scores withColor:(UIColor *)color strokeColor:(UIColor *)strokeColor {

    [self.layerArr makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    if ([scores count] > 5 ) {
        scores = [scores subarrayWithRange:NSMakeRange(0, 5)];
    }else if ([scores count] < 5) {
        NSInteger count = scores.count;
        
        NSMutableArray *score = scores.mutableCopy;
        for (NSInteger index = 0; index < 5 - count; index++) {
            [score addObject:@(0)];
        }
        scores = score.copy;
    }
    
    self.scoreProportion = 1.0;
    
    NSArray *array = [self convertLengthsFromScore:scores];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGPathRef path = [UIBezierPath drawPentagonWithCenter:self.selfCenter LengthArray:array];
    layer.path = path;
    layer.fillColor = color.CGColor;
    layer.strokeColor = strokeColor.CGColor;
    [self.layer addSublayer:layer];
    [self.layerArr addObject:layer];

    
    self.scoreL.text = [self getScore:scores];
    
    self.scores = scores;
}
#pragma mark -
#pragma mark   ==============设置多色层雷达图==============
- (void)setScoreArray:(NSArray<NSNumber *> *)scores withColors:(NSArray<UIColor *> *)colors strokeColors:(NSArray<UIColor *> *)strokeColors {
    
    [self.layerArr makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    
    if ([scores count] > 5 ) {
        scores = [scores subarrayWithRange:NSMakeRange(0, 5)];
    }else if ([scores count] < 5) {
        NSInteger count = scores.count;
        
        NSMutableArray *score = scores.mutableCopy;
        for (NSInteger index = 0; index < 5 - count; index++) {
            [score addObject:@(0)];
        }
        scores = score.copy;
    }
    
    for (NSInteger index = 0; index < colors.count; index++) {
        UIColor *color = colors[index];
        
        UIColor *strokeColor = nil;
        
        if ([strokeColors count] > index) {
            strokeColor = strokeColors[index];
        }
        
        self.scoreProportion = (1.0 - index * 0.2);
        
        
        NSArray *array = [self convertLengthsFromScore:scores];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        CGPathRef path = [UIBezierPath drawPentagonWithCenter:self.selfCenter LengthArray:array];
        layer.path = path;
        layer.fillColor = color.CGColor;
        layer.strokeColor = strokeColor.CGColor;
        [self.layer addSublayer:layer];

        [self.layerArr addObject:layer];
    }
    
    self.scoreL.text = [self getScore:scores];
    
    self.scores = scores;
}
#pragma mark -
#pragma mark   ==============计算平均分值==============
- (NSString *)getScore:(NSArray *)array {
    
    CGFloat score = 0;
    
    for (NSNumber *num in array) {
        score += [num floatValue];
    }
    return [NSString stringWithFormat:@"%.1f",score * 0.2];
}

#pragma mark -
#pragma mark   ==============改变层级+设置五角分值数==============
- (void)springDotView:(NSArray *)scores {
    
    for (NSInteger index = 0; index < 5; index ++) {
        UIView *dotView = self.dotArr[index];
        if (dotView) {
            [self bringSubviewToFront:dotView];
        }
        if (self.type == SHRadarMapViewTypeTitleScore || self.type == SHRadarMapViewTypeScore) {
            UILabel *lb = self.lableArr[index];
            
            if (lb && [lb isKindOfClass:[UILabel class]]) {
                lb.text = @"";
                NSString *title = [NSString stringWithFormat:@"%@",self.titles[index]];
                NSString *score = [NSString stringWithFormat:@"%.0f",[scores[index] floatValue]];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",title,score]];
                [attStr addAttributes:@{NSForegroundColorAttributeName:self.titleScoreColor} range:NSMakeRange(title.length + 1, score.length)];
                lb.attributedText = attStr;
            }

        }
    }
    UIView *dotView = [self viewWithTag:20170608 + 5];
    if (dotView) {
        [self bringSubviewToFront:dotView];
    }
}
#pragma mark -
#pragma mark   ==============UI-lazy==============
- (GLLableStroke *)scoreL {
    if (!_scoreL) {
        _scoreL = [[GLLableStroke alloc] init];
        _scoreL.textAlignment = NSTextAlignmentCenter;
        _scoreL.tag = 20170608 + 5;
    }
    return _scoreL;
}


@end





@implementation GLLableStroke



/**
 绘制描边的lable

 */
- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.strokeWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor whiteColor];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}

@end

