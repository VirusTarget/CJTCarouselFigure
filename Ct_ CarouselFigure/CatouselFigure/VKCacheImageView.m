//
//  CJTImageCache.m
//  Ct_CarouselFigure
//
//  Created by virusKnight on 16/5/15.
//  Copyright © 2016年 virusKnight. All rights reserved.
//

#import "VKCacheImageView.h"

@interface VKCacheImageView()
@property (nonatomic, strong) NSMutableArray<NSURL *> *downloadQueue;
@property (nonatomic, strong) NSURL *imageUrl;
@end

@implementation VKCacheImageView

- (instancetype)init {
    if (self = [super init]) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // 设置自动调整大小
    }
    
    return self;
}

/// 初始化方法，设置图片URL并开始查找缓存中的图片。
/// @param imageUrl 图片的URL
/// @return 初始化后的CJTImageCache实例
- (instancetype)initWithImageUrl:(NSURL *)imageUrl {
    if (self = [self init]) {
        self.imageUrl = imageUrl;
        [self findImageInCache];
    }
    return self;
}

/// 在缓存中查找图片。如果图片存在，则直接显示；否则，显示默认图片并开始下载。
- (void)findImageInCache {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    // 使用URL的最后一部分作为文件名
    NSString *imageName = [self.imageUrl.lastPathComponent stringByDeletingPathExtension];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagePath]) {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    } else {
        // 默认图像需要缓存，所以更推荐使用 imageNamed
        self.image = [UIImage imageNamed:@"Default.jpg"];
        [self downloadImage];
    }
}

/// 下载图片。如果图片已经在下载队列中，则延迟5秒后重试；否则，开始下载。
- (void)downloadImage {
    if ([self.downloadQueue containsObject:self.imageUrl]) {
        // 如果图片已经在下载队列中，延迟5秒后重试
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self findImageInCache];
        });
        return;
    }
    [self.downloadQueue addObject:self.imageUrl];

    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = paths.firstObject;
            // 使用URL的最后一部分作为文件名
            NSString *imageName = [self.imageUrl.lastPathComponent stringByDeletingPathExtension];
            NSURL *destinationURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:imageName]];

            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager moveItemAtURL:location toURL:destinationURL error:nil];
            [self.downloadQueue removeObject:self.imageUrl];
            [self findImageInCache]; // 下载完成后重新查找缓存中的图片
        } else {
            NSLog(@"Error downloading image: %@", error.localizedDescription);
            [self.downloadQueue removeObject:self.imageUrl]; // 移除下载队列中的URL，以便下次重试
        }
    }];
    [task resume];
}

/// MARK: - getter/setter

- (NSMutableArray<NSURL *> *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [NSMutableArray array];
    }
    return _downloadQueue;
}
@end
