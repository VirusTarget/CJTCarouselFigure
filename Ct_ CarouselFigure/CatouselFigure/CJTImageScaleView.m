//
//  ImageScaleView.m
//  CatourselFigure
//
//  Created by virusKnight on 16/9/12.
//  Copyright © 2016年 virusKnight. All rights reserved.
//

#import "CJTImageScaleView.h"

@implementation CJTImageScaleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:219 green:219 blue:219 alpha:0.7];
        self.delegate = self;
        self.minimumZoomScale = 0.1;
        self.maximumZoomScale = 3;
        
        UITapGestureRecognizer  *tap    =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissmask:)];
        [self addGestureRecognizer:tap];
        [tap setNumberOfTapsRequired:1];
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTapGestureRecognizer];
        [tap requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        
        [self addSubview:[UIView new]];
    }
    return self;
}

- (void)createWithImage:(UIImage *)image {
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    [self addSubview:self.imageView];
}

#pragma mark-   手势动作
#pragma mark    单击手势
- (void)dismissmask:(UITapGestureRecognizer*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        sender.view.alpha   =   0;
    } completion:^(BOOL finished) {
        self.imageView  =   nil;
        [sender.view removeFromSuperview];
    }];
}

#pragma mark    双击手势
- (void)doubleTap:(UITapGestureRecognizer*)sender {
    UIScrollView    *view    =   (UIScrollView*)sender.view;
    [UIView animateWithDuration:0.3 animations:^{
        if (view.zoomScale >= 1.5) {
            view.zoomScale  =   1;
        }
        else
            view.zoomScale  =   1.5;
    }];
}

#pragma mark-   <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
