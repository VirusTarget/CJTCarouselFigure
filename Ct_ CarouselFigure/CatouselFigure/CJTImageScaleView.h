//
//  ImageScaleView.h
//  Car-Loan
//
//  Created by chenjintian on 16/9/12.
//  Copyright © 2016年 微小时贷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJTImageScaleView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView       *imageView;

- (void)createWithImage:(UIImage *)image;
@end
