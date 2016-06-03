//
//  MRGestureView.h
//  手势解锁封装
//
//  Created by SinObjectC on 16/6/3.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRGesture;
@protocol MRGestureViewDelegate;

@interface MRGestureView : UIView

/** 手势数据模型 */
@property(nonatomic, strong)MRGesture *gesture;

/** 代理 */
@property(nonatomic, weak)id<MRGestureViewDelegate> delegate;

@end

@protocol MRGestureViewDelegate <NSObject>

@required

/**
 *	@brief	解锁成功的回调方法
 *
 *	@param 	gestureView 	手势视图
 */
- (void)gestureViewUnlockSuccess:(MRGestureView *)gestureView;

@end
