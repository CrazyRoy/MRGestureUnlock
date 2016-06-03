//
//  MRGestureView.m
//  手势解锁封装
//
//  Created by SinObjectC on 16/6/3.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

#import "MRGestureView.h"
#import "MRGesture.h"

@interface MRGestureView ()

/** 选中按钮 */
@property(nonatomic, strong)NSMutableArray *selectedBtns;

/** 当前触摸点 */
@property(nonatomic, assign)CGPoint curPoint;

/** 是否完成连接 */
@property(nonatomic, assign)BOOL finished;

@end

@implementation MRGestureView


- (NSMutableArray *)selectedBtns {
    
    if(!_selectedBtns) {
        
        _selectedBtns = [NSMutableArray array];
        
    }
    
    return _selectedBtns;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 添加手势按钮
        [self addGestureBtns];
    }
    
    return self;
}


/**
 *	@brief	添加手势按钮
 */
- (void)addGestureBtns {

    // 给当前自己添加一个拖动的手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [self addGestureRecognizer:pan];
    
    // 添加手势按钮控件
    for (int i = 0; i < 9; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        
        btn.tag = (i+1);    // 设置tag用户检查手势解锁
        
        btn.userInteractionEnabled = NO;    // 不让用户点击, 防止点击显示高亮状态
        
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        [self addSubview:btn];
    }
    
}


/**
 *	@brief	手势监听事件
 *
 *	@param 	recognizer 	手势
 */
- (void)pan:(UIGestureRecognizer *)recognizer {
    
    // 获取当前触摸点
    self.curPoint = [recognizer locationInView:self];
    
    // 判断当前触摸点是否在按钮上
    for (UIButton *btn in self.subviews) {
        
        // 判断触摸点是否在矩形区域
        if(CGRectContainsPoint(btn.frame, self.curPoint)) {
            
            //并且当前按钮没有被选中
            if(btn.selected == NO) {
                
                // 点在按钮上
                btn.selected = YES; // 设置为选中
            
                [self.selectedBtns addObject:btn];  // 添加到选中按钮数组中
                
            }else { // 如果是被选中
                // 并且是倒数第二个选中的, 那么将可以回退
                if(self.selectedBtns.count > 1 && btn == self.selectedBtns[self.selectedBtns.count-2]) {
                    
                    // 取消选中最有一个选中的按钮
                    UIButton *btn = [self.selectedBtns lastObject];
                    
                    btn.selected = NO;
                    
                    // 从选中数组中移除
                    [self.selectedBtns removeLastObject];
                }
            }
            
        }
    }
   
    // 重绘
    [self setNeedsDisplay];

    // 监听手指松开触摸
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        self.finished = YES;

    }
}


/**
 *	@brief	检查手势解锁是否成功
 */
- (BOOL)checkGestureResult {
    
    // 创建可变字符串
    NSMutableString *result = [NSMutableString string];
    
    // 遍历选中按钮拼接tag
    for (UIButton *btn in self.selectedBtns) {
        
        // 保存连接密码
        [result appendFormat:@"%d", btn.tag];
        
    }
    
    // 返回结果
    return [result isEqualToString:self.gesture.password];
}


/**
 *	@brief	布局子控件
 */
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    int count = self.subviews.count;    // 个数

    int cols = 3;   // 列数
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = 74;
    CGFloat btnH = 74;
    
    CGFloat margin = (self.frame.size.width - (cols * btnW)) / (cols + 1);  // 间距
    
    CGFloat col = 0;
    CGFloat row = 0;
    
    for (int i = 0; i < count; i++) {
        
        UIView *btn = self.subviews[i];
        
        // 获取当前按钮的行列数
        col = i % cols;
        row = i / cols;
        
        btnX = margin + col * (margin + btnW);
        
        btnY = margin + row * (margin + btnW);
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }

}


/**
 *	@brief	重绘方法, 每次调用都会重新刷新页面, 覆盖之前的页面重新绘制
 *
 *	@param 	rect 	区域
 */
- (void)drawRect:(CGRect)rect {

    // 如果没有被选中的按钮, 则不用重新绘制
    if(self.selectedBtns.count == 0) return;
    
    // 把所有选中按钮的中心点连线
    UIBezierPath *path = [UIBezierPath bezierPath];

    NSInteger count = self.selectedBtns.count;
    
    for (int i = 0; i < count; i++) {
        
        UIButton *btn = self.selectedBtns[i];
        
        // 如果是起点
        if(i == 0) {
            
            [path moveToPoint:btn.center];
            
        }else {
            
            [path addLineToPoint:btn.center];
            
        }
    }
    
    // 判断是否松开手指
    if(self.finished) {
        
        if([self checkGestureResult]) { // 解锁成功
        
            [[UIColor blueColor] set];
            
            // 如果实现了解锁成功的代理方法
            if([self.delegate respondsToSelector:@selector(gestureViewUnlockSuccess)]) {
                
                [self.delegate gestureViewUnlockSuccess:self];
                NSLog(@"成功");
            }
            
        }else { // 解锁失败
            
            [[UIColor redColor] set];
        }
        
    }else {
        
        // 将路径描绘到当前的触摸点
        [path addLineToPoint:self.curPoint];
        
        // 设置绘制颜色
        [[UIColor greenColor] set];
    }
    
    // 线宽
    [path setLineWidth:10];
    // 线端圆角
    [path setLineCapStyle:kCGLineCapRound];
    // 线转角圆角
    [path setLineJoinStyle:kCGLineJoinRound];
    
    // 根据路径渲染
    [path stroke];
}

// 点击屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.finished = NO;
    
    // 遍历所有选中的按钮
    for (UIButton *btn in self.selectedBtns) {
        
        // 取消选中状态
        btn.selected = NO;
        
    }
    
    [self.selectedBtns removeAllObjects];
    
    // 重绘
    [self setNeedsDisplay];
    
}
@end
