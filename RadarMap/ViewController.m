//
//  ViewController.m
//  RadarMap
//
//  Created by angle on 2017/6/9.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "ViewController.h"

#import "SHRadarMapView.h"

@interface ViewController ()<SHRadarMapViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    
    CGFloat width = self.view.frame.size.width;
    CGFloat width1 = width - 32;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    
    NSArray *titles = @[@"上单",@"中单",@"下路",@"打野",@"辅助"];
    
    CGFloat height = 50;
    for (NSInteger index = 0; index < 4; index ++) {
        
        SHRadarMapViewType type = index;
        
        SHRadarMapView *map = [SHRadarMapView radarMapView:CGRectMake(16, 50 + (width1 * 0.68 + 30) * index, width1, width1 * 0.68) radius:90 titles:titles bigScore:10 type:type];
        map.backgroundColor = [UIColor clearColor];
        map.delegate = self;
        
        map.bottomColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        map.titlesColor = [UIColor colorWithHexString:@"666666"];
        map.titleFont = [UIFont systemFontOfSize:13];
        map.lineColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        map.lineWidth = 1.f;
        map.dotColor = [UIColor yellowColor];
        map.dotRadius = 4;
        map.titleScoreColor = [UIColor redColor];
        map.scoreColor = [UIColor purpleColor];
        map.scoreFont = [UIFont systemFontOfSize:35];
        map.scoreStrokeColor = [UIColor whiteColor];
        map.scoreStrokeWidth = 2.5f;
        map.strokeColor = [UIColor blueColor];
//        map.layerNum = 1;//默认一层底色层
        
        //一层分值
        [map setScoreArray:@[@(9),@(8),@(10),@(5),@(7)] withColor:[[UIColor greenColor] colorWithAlphaComponent:0.3] strokeColor:[UIColor blueColor]];
        //三层分值
//        [map setScoreArray:@[@(9),@(8),@(10),@(5),@(7)] withColors:@[[[UIColor greenColor] colorWithAlphaComponent:0.3] ,[[UIColor greenColor] colorWithAlphaComponent:0.3] ,[[UIColor greenColor] colorWithAlphaComponent:0.3] ] strokeColors:@[[UIColor blueColor],[UIColor blueColor],[UIColor blueColor]]];
        
        [scrollView addSubview:map];
        
        height += (width1 * 0.68 + 30);
    }
    
    
    for (NSInteger index = 0; index < 4; index++) {
        
        SHRadarMapViewType type = index;
        
        SHRadarMapView *map = [SHRadarMapView radarMapView:CGRectMake(16, height + (width1 * 0.68 + 30) * index, width1, width1 * 0.68) radius:90 titles:titles bigScore:10 type:type];
        map.backgroundColor = [UIColor clearColor];
        map.delegate = self;
        
        map.bottomColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        map.titlesColor = [UIColor colorWithHexString:@"666666"];
        map.titleFont = [UIFont systemFontOfSize:13];
        map.lineColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        map.lineWidth = 1.f;
        map.dotColor = [UIColor orangeColor];
        map.dotRadius = 4;
        map.titleScoreColor = [UIColor redColor];
        map.scoreColor = [UIColor purpleColor];
        map.scoreFont = [UIFont systemFontOfSize:35];
        map.scoreStrokeColor = [UIColor whiteColor];
        map.scoreStrokeWidth = 2.5f;
        map.strokeColor = [UIColor purpleColor];
        map.layerNum = 3;//三层底色层
        
        //一层分值

//        [map setScoreArray:@[@(9),@(8),@(10),@(5),@(7)] withColor:[[UIColor greenColor] colorWithAlphaComponent:0.3] strokeColor:[UIColor blueColor]];
        
        
        
        //三层分值

        [map setScoreArray:@[@(9),@(8),@(10),@(5),@(7)] withColors:@[[[UIColor greenColor] colorWithAlphaComponent:0.3] ,[[UIColor greenColor] colorWithAlphaComponent:0.3] ,[[UIColor greenColor] colorWithAlphaComponent:0.3] ] strokeColors:@[[UIColor blueColor],[UIColor blueColor],[UIColor blueColor]]];
        
        
        [scrollView addSubview:map];

        if (index == 3) {
            scrollView.contentSize = CGSizeMake(width, CGRectGetMaxY(map.frame));
        }
    }
    
    [self.view addSubview:scrollView];
    
    
}

#pragma mark -
#pragma mark   ==============SHRadarMapViewDelegate==============
- (void)SHRadarMapView:(SHRadarMapView *)radarView {
    NSLog(@"点击雷达图");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
