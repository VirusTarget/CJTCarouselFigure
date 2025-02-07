//
//  ImageScaleView.h
//  CatourselFigure
//
//  Created by virusKnight on 16/9/12.
//  Copyright © 2016年 virusKnight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJTImageScaleView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView       *imageView;

- (void)createWithImage:(UIImage *)image;
@end
