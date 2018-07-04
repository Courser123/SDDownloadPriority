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

@interface SDDownloadViewController ()

@property (nonatomic, strong) NSArray<NSString *> *URLs;

@end

@implementation SDDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.URLs = [ImageViewHelper remoteUrlList];
    [self showSDImage];
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

@end
