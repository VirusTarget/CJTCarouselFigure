//
//  VKImageCacheManager.h
//  Ct_CarouselFigure
//
//  Created by virusKnight on 16/5/15.
//  Copyright © 2016年 virusKnight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VKImageCacheManager : NSObject

+ (instancetype)sharedManager;

- (void)findImageInCacheForImageView:(UIImageView *)imageView withImageUrl:(NSURL *)imageUrl;

@end