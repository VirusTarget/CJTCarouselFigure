//
//  CarouselFigure1.h
//  Ct_CarouselFigure
//
//  Created by virusKnight on 16/5/13.
//  Copyright © 2016年 virusKnight. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 无限循环轮播图，可支持在线图片与本地图片混合使用
 */
@interface CJTCarouselFigure : UIScrollView <UIScrollViewDelegate>

/// 是否开启定时器
@property (nonatomic,assign) Boolean openTimer;

/// 图片数组，包含 UIImage 或 NSURL 对象
@property (nonatomic,strong) NSArray *picArray;

#pragma mark- method

/// 初始化方法，接受一个frame和图片数组
/// @param frame 控件的frame
/// @param picArray 图片数组
/// @return CJTCarouselFigure实例
- (instancetype)initWithFrame:(CGRect)frame picArray:(NSArray *)Pic;

/// 关闭计时器
- (void)stopTimer;

/// 关闭pagecontroller显示
- (void)hidePageControl;

@end
