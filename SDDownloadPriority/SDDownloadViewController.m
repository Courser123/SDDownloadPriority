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

@end

@implementation SDDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.URLs = [ImageViewHelper remoteUrlList];
    [self downloadImages];
}

- (void)downloadImages {
    if (self.mark > 0) {
        for (int i = 30; i < 40; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.view addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.URLs[i]] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"downloadfinished : %@",@(i));
            }];
        }
    }else {
        for (int i = 0; i < 30; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.view addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.URLs[i]] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"downloadfinished : %@",@(i));
            }];
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
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
