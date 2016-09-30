//
//  PicCache.h
//  Ct_CarouselFigure
//
//  Created by CJT on 16/5/15.
//  Copyright © 2016年 CJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCache : UIScrollView
{
@private NSURL* __URL;  //获取地址
}
@property (nonatomic,strong) UIImageView *imageV;

-(instancetype)initWithURL:(NSURL*)URL;
@end
