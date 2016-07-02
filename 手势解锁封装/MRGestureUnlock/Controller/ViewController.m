//
//  ViewController.m
//  手势解锁封装
//
//  Created by SinObjectC on 16/6/3.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

#import "ViewController.h"
#import "MRGestureBgView.h"
#import "MRScuuessViewController.h"
#import "MRGestureView.h"
#import "MRGesture.h"

@interface ViewController ()<MRGestureViewDelegate>

/** 背景控件 */
@property(nonatomic, strong)MRGestureBgView *bgView;

/** 手势解锁控件 */
@property(nonatomic, strong)MRGestureView *gestureView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 初始化
    [self setupGesture];
}


/**
 *	@brief	初始化手势相关控件
 */
- (void)setupGesture {
    
    // 将控制器的view设置为手势背景图的view
    self.bgView = [[MRGestureBgView alloc] init];
    
    self.bgView.frame = self.view.bounds;
    
    self.view = self.bgView;
    
    // 添加手势视图
    self.gestureView = [[MRGestureView alloc] init];
    
    self.gestureView.delegate = self;
    
    MRGesture *gesture = [[MRGesture alloc] init];
    
    // 设置密码
    gesture.password = @"147895";
    
    self.gestureView.gesture = gesture;
    
    self.gestureView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.gestureView];
    
}

#pragma mark - <MRGestureViewDelegate>

- (void)gestureViewUnlockSuccess:(MRGestureView *)gestureView {
    
    [self presentViewController:[[MRScuuessViewController alloc] init] animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
