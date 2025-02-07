//
//  CJTCarouselFigure.m
//  Ct_CarouselFigure
//
//  Created by virusKnight on 16/5/13.
//  Copyright © 2016年 virusKnight. All rights reserved.
//

#import "CJTCarouselFigure.h"
#import "VKCacheImageView.h"
#import "CJTImageScaleView.h"

@interface CJTCarouselFigure()
@property (nonatomic, assign) CGFloat height; // 获取控件高度
@property (nonatomic, assign) CGFloat width; // 获取控件宽度
@property (nonatomic, strong) UIPageControl *pageControl; // 设置点控制器
@property (nonatomic, strong) NSTimer *timer; // 设置计时器
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViewArray;

@end

@implementation CJTCarouselFigure

/// 初始化方法，接受一个frame和图片数组
/// @param frame 控件的frame
/// @param picArray 图片数组
/// @return CJTCarouselFigure实例
- (instancetype)initWithFrame:(CGRect)frame picArray:(NSArray *)picArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.picArray = [NSArray arrayWithArray:picArray];
    }
    return self;
}

/// 初始化方法，接受一个frame
/// @param frame 控件的frame
/// @return CJTCarouselFigure实例
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.scrollEnabled = YES;
        self.delegate = self;
        
        // 添加手势识别器，用于显示大图
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPicture)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

// 放入图片
- (void)inputPictures {
    for (NSInteger i = 1; i <= self.picArray.count; i++) {
        [self judgeImageOrURL:i];
    }
    [self judgeImageOrURL:0];
    [self judgeImageOrURL:self.picArray.count + 1];
}

#pragma mark - UIScrollViewDelegate

/// 图片循环
/// @param scrollView UIScrollView实例
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_timer) {
        [self.timer invalidate];
    }
    NSInteger picCount = self.picArray.count;
    if (self.contentOffset.x >= (picCount + 1) * self.width) { // 如果是最后一张则转到第一张
        self.contentOffset = CGPointMake(self.width, 0);
    } else if (self.contentOffset.x < self.width) { // 如果为第一张则转到最后一张
        self.contentOffset = CGPointMake((picCount + 1) * self.width - self.width, 0);
    }
}

/// 点的位置
/// @param scrollView UIScrollView实例
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (self.contentOffset.x / self.width) - 1;
    if (self.openTimer) {
        self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(changeByTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

/// 点的位置
/// @param scrollView UIScrollView实例
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (self.contentOffset.x / self.width) - 1;
    if (self.openTimer) {
        self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(changeByTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - 图片缓存

/// 判断为图片还是网址
/// @param index 图片索引
- (void)judgeImageOrURL:(NSInteger)index {
    CGFloat imageViewWidth = index * self.width;
    if (index == 0) {
        index = self.picArray.count;
    } else if (index > self.picArray.count) {
        index = 1;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth, 0, self.width, self.height)];
    if ([self.picArray[index - 1] isKindOfClass:[NSURL class]]) {
        UIImageView *cachedImageView = [self cachedImageViewForURL:self.picArray[index - 1]];
        cachedImageView.frame = imageView.frame;
        [self addSubview:cachedImageView];
        [self.imageViewArray addObject:cachedImageView];
    } else {
        UIImage *image = self.picArray[index - 1];
        [imageView setImage:image];
        [self addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
    imageView.userInteractionEnabled = NO;
}

/// 从缓存中读取文件
/// @param url 图片URL
/// @return 缓存的UIImageView
- (UIImageView *)cachedImageViewForURL:(NSURL *)url {
    return [[VKCacheImageView alloc] initWithImageUrl:url];
}

#pragma mark - Event Response

/// 显示大图
- (void)showBigPicture {
    NSInteger index = self.contentOffset.x / self.width; // 定位到现在是什么位置
    CJTImageScaleView *imageScaleView = [[CJTImageScaleView alloc] initWithFrame:self.superview.bounds];
    [self.superview addSubview:imageScaleView];
    [imageScaleView createWithImage:[self.imageViewArray[index] image]];
}

/// pageControl点击事件
/// @param sender UIPageControl实例
- (void)pageControlTapped:(UIPageControl *)sender {
    [self setContentOffset:CGPointMake(sender.currentPage * self.width, 0) animated:YES];
}

/// 计时器动作
- (void)changeByTimer {
    [self setContentOffset:CGPointMake(self.contentOffset.x + self.width, 0) animated:YES];
}

/// 关闭计时器
- (void)stopTimer {
    [self.timer invalidate];
    self.openTimer = NO;
}

/// 关闭pageControl显示
- (void)hidePageControl {
    self.pageControl.hidden = YES;
}

#pragma mark - Getter/Setter

/// 获取或设置 imageViewArray
- (NSMutableArray<UIImageView *> *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

/// 设置图片数组
/// @param picArray 图片数组
- (void)setPicArray:(NSArray *)picArray {
    _picArray = picArray;
    
    self.imageViewArray = [NSMutableArray array];
    self.contentSize = CGSizeMake(self.width * (self.picArray.count + 2), self.height);
    self.contentOffset = CGPointMake(self.width, 0);
    self.openTimer = YES;
    
    [self timer];
    [self inputPictures];
}

/// 获取或设置 pageControl
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.origin.x + self.width * 0.7, self.frame.origin.y + self.height - 25, self.width * 0.3, 20)];
        [_pageControl setNumberOfPages:self.picArray.count];
        _pageControl.currentPage = 0;
        _pageControl.backgroundColor = [UIColor clearColor];
        
        [_pageControl addTarget:self action:@selector(pageControlTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:_pageControl];
    }
    return _pageControl;
}

/// 获取或设置 timer
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(changeByTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(pageControl) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

/// 懒加载 height
- (CGFloat)height {
    if (_height == 0) {
        _height = self.frame.size.height;
    }
    return _height;
}

/// 懒加载 width
- (CGFloat)width {
    if (_width == 0) {
        _width = self.frame.size.width;
    }
    return _width;
}

@end
