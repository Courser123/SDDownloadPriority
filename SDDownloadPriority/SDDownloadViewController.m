//
//  SDDownloadViewController.m
//  SDDownloadPriority
//
//  Created by Courser on 2018/7/4.
//  Copyright © 2018 Courser. All rights reserved.
//

#import "SDDownloadViewController.h"
#import <UIImageView+WebCache.h>
#import "ImageViewHelper.h"
#import <SDImageCache.h>

@interface SDDownloadViewController ()

@property (nonatomic, strong) NSArray<NSString *> *URLs;
@property (nonatomic, assign) double start;
@property (nonatomic, assign) BOOL first;

@end

@implementation SDDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.URLs = [ImageViewHelper remoteUrlList];
    self.first = YES;
    [self downloadImages];
}

- (void)downloadImages {
    self.start = CACurrentMediaTime();
    if (self.mark > 0) {
        for (int i = 100; i < 110; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.URLs[i]] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (self.first) {
                    self.title = [NSString stringWithFormat:@"%lf",CACurrentMediaTime() - self.start];
                    self.first = NO;
                }
                if (cacheType == SDImageCacheTypeNone) {
                    NSLog(@"downloadfinished : %@",@(i));
                }else if (cacheType == SDImageCacheTypeMemory) {
                    NSLog(@"hit memory cache");
                }else {
                    NSLog(@"hit disk cache");
                }
            }];
        }
    }else {
        for (int i = 0; i < 100; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.URLs[i]] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (cacheType == SDImageCacheTypeNone) {
                    NSLog(@"downloadfinished : %@",@(i));
                }else if (cacheType == SDImageCacheTypeMemory) {
                    NSLog(@"hit memory cache");
                }else {
                    NSLog(@"hit disk cache");
                }
            }];
//            NSLog(@"retainCount : %ld",CFGetRetainCount((__bridge CFTypeRef) imageView));
        }
    }
}

- (void)showSDImage {
    UIImageView *sdImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [sdImageView sd_setImageWithURL:[NSURL URLWithString:self.URLs.firstObject] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    [self.view addSubview:sdImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"SDDownloadViewController dealloc");
    if (self.mark <= 0) {
        [[SDImageCache sharedImageCache] clearMemory];
    }
}

@end
