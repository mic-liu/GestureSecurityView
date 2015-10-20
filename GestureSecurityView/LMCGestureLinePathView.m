//
//  LMCGestureLinePathView.m
//  GestureSecurityView
//
//  Created by LiuMingchuan on 15/10/19.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "LMCGestureLinePathView.h"

@implementation LMCGestureLinePathView{
    /**
     *  存储滑动到的圆环的视图数组
     */
    NSMutableArray *_lineNodeArray;
    /**
     *  存储9个圆环视图数组
     */
    NSMutableArray *_crCenterPointArray;
    /**
     *  触摸点
     */
    CGPoint _touchPoint;
}

/**
 *  初始化
 *
 *  @param frame 布局
 *
 *  @return 实例
 */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _lineNodeArray = [[NSMutableArray alloc]init];
        _crCenterPointArray = [[NSMutableArray alloc]init];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addCircleViewToSelf];
    }
    return self;
}

/**
 *  绘制
 *
 *  @param rect 布局
 */
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    if (_lineNodeArray.count >0) {
        //移向第一个点
        UIView *firstV = (UIView*)[_lineNodeArray objectAtIndex:0];
        CGPoint firstPoint = firstV.center;
        [[firstV.layer sublayers]objectAtIndexedSubscript:1].hidden = NO;
        CGPathMoveToPoint(path, nil, firstPoint.x, firstPoint.y);
        for (int i=1; i<_lineNodeArray.count; i++) {
            //从第二个点开始连线
            UIView *v = (UIView*)[_lineNodeArray objectAtIndex:i];
            CGPoint point = v.center;
            [[v.layer sublayers]objectAtIndexedSubscript:1].hidden = NO;
            CGPathAddLineToPoint(path, nil, point.x, point.y);
        }
        //绘制和触摸点之间的连线
        CGPathAddLineToPoint(path, nil, _touchPoint.x, _touchPoint.y);
    }
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 10);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
}

/**
 *  创建环形视图
 *
 *  @return 环形视图
 */
- (UIView*)makeCircleView{
    //创建环形视图：为view添加layer
    UIView *circleView = [[UIView alloc]init];
    [circleView setBounds:CGRectMake(0, 0, 50, 50)];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(25, 25) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.fillMode = kCAFillRuleEvenOdd;
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.lineWidth = 2;
    [shapeLayer setFrame:circleView.bounds];
    shapeLayer.path = path.CGPath;
    circleView.layer.shouldRasterize = YES;
    [circleView.layer insertSublayer:shapeLayer atIndex:0];
    
    UIBezierPath *pathNode = [UIBezierPath bezierPath];
    [pathNode addArcWithCenter:CGPointMake(25, 25) radius:7 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *nodeLayer = [CAShapeLayer layer];
    nodeLayer.fillColor = [UIColor clearColor].CGColor;
    nodeLayer.fillMode = kCAFillRuleEvenOdd;
    nodeLayer.strokeColor = [UIColor grayColor].CGColor;
    nodeLayer.lineWidth = 2;
    [nodeLayer setFrame:circleView.bounds];
    nodeLayer.path = pathNode.CGPath;
    nodeLayer.hidden = YES;
    [circleView.layer insertSublayer:nodeLayer atIndex:1];
    
    return circleView;
}

/**
 *  添加环形视图
 */
- (void)addCircleViewToSelf {
    int tag = 0X1000;
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            UIView *cr = [self makeCircleView];
            //tag用作以后形成密码（1-9）
            cr.tag = ++tag;
            cr.center = CGPointMake((self.center.x-self.frame.size.width/3)+(self.frame.size.width/3)*j, (self.center.y-self.frame.size.width/3)+(self.frame.size.width/3)*i);
            //形成9个环形视图，存入数组
            [_crCenterPointArray addObject:cr];
            [self addSubview:cr];
        }
    }
    
}

/**
 *  开始描绘
 *
 *  @param touches 触摸
 */
- (void)startDrawPath:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for (UIView *crView in _crCenterPointArray) {
        //遍历9个视图，取出中心点
        CGPoint cPoint = crView.center;
        //视图中心点和触摸点的距离的计算
        CGFloat difX = fabs(point.x-cPoint.x);
        CGFloat difY = fabs(point.y-cPoint.y);
        CGFloat dis = sqrtf(difX*difX + difY*difY);
        //距离和环形半径比较
        if (dis < 25) {
            //触摸点在圆环内，并且新的存储圆环形视图的数组的最后一个视图 不是当前的视图的话，保存进数组
            if ([_lineNodeArray lastObject] != crView) {
                [_lineNodeArray addObject:crView];
            }
        }
    }
    //设置当前的触摸点
    _touchPoint = point;
    //重绘视图
    [self setNeedsDisplay];
}

/**
 *  结束描绘
 */
-(void)endDrawPath{
    if (_isSetMode) {
        _touchPoint = ((UIView*)[_lineNodeArray lastObject]).center;
        [self setNeedsDisplay];
        //设定密码场合下，密码绘制完成后，弹出确认视图
        UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"确认信息" message:@"是否保存当前绘制的密码？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //简单的将密码存储
            NSString *psd = [self arrayToPWDString];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:psd forKey:@"gesturePWD"];
            NSLog(@"psd---> %@",psd);
            //存储完成后，清空数组、触摸点 重绘视图
            [self resetPWD];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //取消，不存储密码
            [self resetPWD];
            
        }];
        [confirm addAction:okAction];
        [confirm addAction:cancelAction];
        
        [[self getSelfController] presentViewController:confirm animated:YES completion:^{}];
    } else {
        _touchPoint = ((UIView*)[_lineNodeArray lastObject]).center;
        [self setNeedsDisplay];
        NSString *strPWD = [[NSUserDefaults standardUserDefaults]valueForKey:@"gesturePWD"];
        NSString *drawPsd = [self arrayToPWDString];
        NSLog(@"drawPsd---> %@",drawPsd);
        if ([strPWD isEqual:drawPsd]) {
            [self showAlertView:@"密码正确"];
        } else {
            [self showAlertView:@"密码错误，再次确认输入！"];
        }
    }
}

/**
 *  重设密码
 */
- (void)resetPWD {
    for (UIView *v in _lineNodeArray) {
        [v.layer.sublayers objectAtIndex:1].hidden = YES;
    }
    //清空数组，重置触摸点，重绘视图
    [_lineNodeArray removeAllObjects];
    _touchPoint = CGPointZero;
    [self setNeedsDisplay];
}

/**
 *  获取视图控制器
 *
 *  @return 控制器
 */
- (id)getSelfController {
    //获取当前视图的控制器
    id viewCtrl = self;
    while (viewCtrl) {
        viewCtrl = ((UIResponder*)viewCtrl).nextResponder;
        if ([viewCtrl isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return viewCtrl;
}

/**
 *  提示信息框
 *
 *  @param info 提示信息
 */
- (void)showAlertView:(NSString *)info {
    //设定密码场合下，密码绘制完成后，弹出确认视图
    UIAlertController *infoAlert = [UIAlertController alertControllerWithTitle:@"提示信息" message:info preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self resetPWD];
    }];
    [infoAlert addAction:cancelAction];
    [[self getSelfController] presentViewController:infoAlert animated:YES completion:^{}];
}

/**
 *  获取密码
 *
 *  @return 密码
 */
- (NSString *)arrayToPWDString {
    NSMutableString *strPWD = [[NSMutableString alloc]init];
    for (UIView *view in _lineNodeArray) {
        [strPWD appendString:[NSString stringWithFormat:@"%ld",(view.tag-0X1000)]];
    }
    return strPWD;
}


@end
