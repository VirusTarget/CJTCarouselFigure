//
//  VKImageCacheManager.m
//  Ct_CarouselFigure
//
//  Created by virusKnight on 16/5/15.
//  Copyright © 2016年 virusKnight. All rights reserved.
//

#import "VKImageCacheManager.h"

@interface VKImageCacheManager()
@property (nonatomic, strong) NSMutableDictionary<NSURL *, NSMutableArray<UIImageView *> *> *imageRequestMap;
@property (nonatomic, strong) NSMutableArray<NSURL *> *downloadQueue;
@end

@implementation VKImageCacheManager

+ (instancetype)sharedManager {
    static VKImageCacheManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageRequestMap = [NSMutableDictionary dictionary];
        _downloadQueue = [NSMutableArray array];
    }
    return self;
}

- (void)findImageInCacheForImageView:(UIImageView *)imageView withImageUrl:(NSURL *)imageUrl {
    if ([self.imageRequestMap objectForKey:imageUrl]) {
        NSMutableArray *imageViews = [self.imageRequestMap objectForKey:imageUrl];
        [imageViews addObject:imageView];
    } else {
        NSMutableArray *imageViews = [NSMutableArray arrayWithObject:imageView];
        [self.imageRequestMap setObject:imageViews forKey:imageUrl];
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    // 使用URL的最后一部分作为文件名
    NSString *imageName = [imageUrl.lastPathComponent stringByDeletingPathExtension];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagePath]) {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        for (UIImageView *view in [self.imageRequestMap objectForKey:imageUrl]) {
            view.image = image;
        }
        [self.imageRequestMap removeObjectForKey:imageUrl];
    } else {
        for (UIImageView *view in [self.imageRequestMap objectForKey:imageUrl]) {
            view.image = [UIImage imageNamed:@"Default.jpg"];
        }
        [self downloadImage:imageUrl];
    }
}

- (void)downloadImage:(NSURL *)imageUrl {
    if ([self.downloadQueue containsObject:imageUrl]) {
        // 如果图片已经在下载队列中，延迟5秒后重试
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self findImageInCacheForImageView:nil withImageUrl:imageUrl];
        });
        return;
    }
    [self.downloadQueue addObject:imageUrl];

    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = paths.firstObject;
            // 使用URL的最后一部分作为文件名
            NSString *imageName = [imageUrl.lastPathComponent stringByDeletingPathExtension];
            NSURL *destinationURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:imageName]];

            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager moveItemAtURL:location toURL:destinationURL error:nil];
            [self.downloadQueue removeObject:imageUrl];
            [self findImageInCacheForImageView:nil withImageUrl:imageUrl]; // 下载完成后重新查找缓存中的图片
        } else {
            NSLog(@"Error downloading image: %@", error.localizedDescription);
            [self.downloadQueue removeObject:imageUrl]; // 移除下载队列中的URL，以便下次重试
        }
    }];
    [task resume];
}

@end