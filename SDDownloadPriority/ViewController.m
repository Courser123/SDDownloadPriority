//
//  ViewController.m
//  SDDownloadPriority
//
//  Created by Courser on 2018/7/4.
//  Copyright © 2018 Courser. All rights reserved.
//

#import "ViewController.h"
#import "SDDownloadViewController.h"
#import <UIImageView+WebCache.h>
#import "ImageViewHelper.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray<NSString *> *URLs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    self.URLs = [ImageViewHelper remoteUrlList];
//    [self showSDImage];
}

- (void)showSDImage {
    UIImageView *sdImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [sdImageView sd_setImageWithURL:[NSURL URLWithString:self.URLs.firstObject] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    [self.view addSubview:sdImageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SDDownloadViewController *vc = [[SDDownloadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
