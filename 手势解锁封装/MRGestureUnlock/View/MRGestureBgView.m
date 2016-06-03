//
//  MRGestureBgView.m
//  手势解锁封装
//
//  Created by SinObjectC on 16/6/3.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

#import "MRGestureBgView.h"

@implementation MRGestureBgView


// 在重绘的方法里面绘制背景图片
- (void)drawRect:(CGRect)rect {
    
    UIImage *bgImage = [UIImage imageNamed:@"Home_refresh_bg"];
    
    [bgImage drawInRect:rect];
}

@end
