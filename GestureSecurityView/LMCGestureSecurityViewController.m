//
//  LMCGestureSecurityViewController.m
//  GestureSecurityView
//
//  Created by LiuMingchuan on 15/10/18.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "LMCGestureSecurityViewController.h"
#import "LMCGestureLinePathView.h"

@interface LMCGestureSecurityViewController (){

    LMCGestureLinePathView *view;
}

@end

@implementation LMCGestureSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view = [[LMCGestureLinePathView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    view.center = self.view.center;
    [self.view addSubview:view];
    
    if (_isSetMode) {
        [self setTitle:@"SetGesturePassword"];
        [view setIsSetMode:YES];
    } else {
        [self setTitle:@"TestGesturePassword"];
        [view setIsSetMode:NO];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /**
     *  开始描绘
     */
    [view startDrawPath:touches];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /**
     *  结束描绘
     */
    [view endDrawPath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
