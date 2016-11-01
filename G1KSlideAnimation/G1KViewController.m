//
//  G1KViewController.m
//  demo
//
//  Created by Sobf Leo on 16/11/1.
//  Copyright © 2016年 SOBF. All rights reserved.
//

#import "G1KViewController.h"

@interface G1KViewController ()<CALayerDelegate>
@property (nonatomic,assign) CGMutablePathRef  path; // 路径容器
@property (nonatomic,strong) CALayer * lineLayer;// 线
@property (nonatomic,strong) CALayer * diamondLayer;//方块
@end

@implementation G1KViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init layer
    [self initLayer];
}
#pragma mark -init layer
-(void)initLayer{
    
    [self.view.layer addSublayer:self.lineLayer];
    [self.view.layer addSublayer:self.diamondLayer];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     // 创建路径容器
    self.path = CGPathCreateMutable();
    if (self.path) {
        // 找到 触摸点
        UITouch * touch = [touches anyObject];
        CGPoint point = [touch locationInView:touch.view];
        // 从这个点开始移动
        CGPathMoveToPoint(self.path, nil, point.x, point.y);

    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.path) {
        // 找到起始点
        UITouch * touch = [touches anyObject];
        CGPoint point = [touch locationInView:touch.view];
        // 移动
        CGPathAddLineToPoint(self.path, nil, point.x, point.y);
        [self.lineLayer setNeedsDisplay];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 触摸结束 就是一个 动画
    CAKeyframeAnimation * animation = [[CAKeyframeAnimation alloc]init];
    animation.duration = 6;
    animation.path = self.path;
    animation.keyPath = @"position";
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.diamondLayer addAnimation:animation forKey:@"key"];
    if (self.path) {
        CGPathRelease(self.path);
    }
}

#pragma mark - layer delegate
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGContextAddPath(ctx, self.path);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextDrawPath(ctx, kCGPathStroke);
}
#pragma mark - lazy
-(CALayer*)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc]init];
        _lineLayer.position = self.view.layer.position;
        _lineLayer.anchorPoint = self.view.layer.anchorPoint;
        _lineLayer.bounds = self.view.bounds;
        _lineLayer.delegate = self;
    }
    return _lineLayer;
}
-(CALayer*)diamondLayer{
    if (!_diamondLayer) {
        _diamondLayer = [[CALayer alloc]init];
        _diamondLayer.frame = CGRectMake(0, 0, 40,40);
        _diamondLayer.position = CGPointMake(100, 100);
        _diamondLayer.backgroundColor = [UIColor cyanColor].CGColor;
        
    }
    return _diamondLayer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
