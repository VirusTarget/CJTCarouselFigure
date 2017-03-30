//
//  PicCache.m
//  Ct_CarouselFigure
//
//  Created by jkc on 16/5/15.
//  Copyright © 2016年 CJT. All rights reserved.
//

#import "CJTPicCache.h"

@interface CJTPicCache()
@property (nonatomic, strong) NSMutableArray *urlArr;
@end
@implementation CJTPicCache

-(instancetype)initWithURL:(NSURL*)URL{
    if (self = [super init]) {
        __URL = URL;
        [self FindIfInCache];
    }
    return self;
}

/*在缓存中寻找图片*/
-(void)FindIfInCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    //只截取在最后一个“/”后面的字符串
    NSRange range = [[__URL relativeString] rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *str = [[__URL absoluteString] substringFromIndex:range.location+1];
    NSString *PicPath = [NSString stringWithFormat:@"%@/%@",docDir,str];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:PicPath isDirectory:NULL]) {//如果存在文件，则直接返回该图片
        NSData *data = [fm contentsAtPath:PicPath];
        UIImage *image = [UIImage imageWithData:data];
        [self.imageV setImage:image];
    }
    else//如果本地找不到图片的话使用默认图片
    {
        [self.imageV setImage:[UIImage imageNamed:@"Default.jpg"]];
        [self DownLoadPic];
    }
}

/*下载图片*/
-(void)DownLoadPic
{
    if ([self.urlArr containsObject:__URL]) {//如果在下载线程中发现该图片正在下载，则5s后再重试
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self FindIfInCache];
        });
        return;
    }
    [self.urlArr addObject:__URL];
    
    NSURLRequest *Request = [NSURLRequest requestWithURL:__URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:Request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex:0];
            
            NSRange range = [[__URL relativeString] rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *str = [[__URL absoluteString] substringFromIndex:range.location+1];
            NSURL *docURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",docDir,str]];
            
            [self.urlArr removeObject:__URL];
            [fileManager moveItemAtURL:location toURL:docURL error:nil];
            [self FindIfInCache];//保存之后重新写入文件
        }
    }];
    [task resume];
}

-(UIImageView *)imageV
{
    if (!_imageV) {
        self.imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}


@end
