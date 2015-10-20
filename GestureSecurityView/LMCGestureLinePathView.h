//
//  LMCGestureLinePathView.h
//  GestureSecurityView
//
//  Created by LiuMingchuan on 15/10/19.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMCGestureLinePathView : UIView

/**
 *  是否是密码设定模式
 */
@property (nonatomic,assign) BOOL isSetMode;

/**
 *  结束描绘
 */
-(void)endDrawPath;

/**
 *  开始描绘
 *
 *  @param touches 触摸
 */
- (void)startDrawPath:(NSSet<UITouch *> *)touches;

@end
