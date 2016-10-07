//
//  ViewController.m
//  Ct_ CarouselFigure
//
//  Created by CJT on 16/4/18.
//  Copyright © 2016年 CJT. All rights reserved.
//

#import "ViewController.h"
#import "JT_CarouselFigure.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [NSArray arrayWithObjects:[UIImage imageNamed:@"Default.jpg"],[UIImage imageNamed:@"Default.jpg"], [NSURL URLWithString:@"http://liaoning.sinaimg.cn/2014/1111/U10435P1195DT20141111220802.jpg"],[NSURL URLWithString:@"http://photocdn.sohu.com/20151124/mp43786429_1448294862260_4.jpeg"],nil];
    
    JT_CarouselFigure *bcd = [[JT_CarouselFigure alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) AndPicArr:arr];
    [self.view addSubview:bcd];
    
    JT_CarouselFigure *bcdf = [[JT_CarouselFigure alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 300)];
    bcdf.PicArr =   arr;
    [bcdf updatePicArr];
    [self.view addSubview:bcdf];
}


@end
