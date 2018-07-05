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
    [self showSDButton];
}

- (void)showSDButton {
    UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.5)];
    topButton.tag = 0;
    topButton.backgroundColor = [UIColor greenColor];
    [topButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topButton];
    
    UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 0.5, self.view.bounds.size.width, self.view.bounds.size.height * 0.5)];
    bottomButton.tag = 1;
    bottomButton.backgroundColor = [UIColor redColor];
    [bottomButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}

- (void)btnClick:(UIButton *)btn {
    SDDownloadViewController *vc = [[SDDownloadViewController alloc] init];
    vc.mark = btn.tag;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    SDDownloadViewController *vc = [[SDDownloadViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
