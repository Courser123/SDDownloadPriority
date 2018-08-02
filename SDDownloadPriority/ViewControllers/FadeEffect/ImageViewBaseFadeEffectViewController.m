//
//  ImageViewBaseFadeEffectViewController.m
//  ImageViewBase_Example
//
//  Created by welson on 2018/2/28.
//  Copyright © 2018年 welson. All rights reserved.
//

#import "ImageViewBaseFadeEffectViewController.h"
#import "UGCCommonSheetView.h"
#import "ImageViewHelper.h"
#import "ImageViewBaseFadeEffectCell.h"
#import "SDImageCache.h"

@interface ImageViewBaseFadeEffectViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSString *> *picUrls;

@property (nonatomic, assign) BOOL enableFadeEffect;
@property (nonatomic, assign) FadeEffectCellLoadingFrame loadingFrame;

@end

@implementation ImageViewBaseFadeEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void)initData {
    [self clearLocalCache];
    self.picUrls = [ImageViewHelper remoteUrlList];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showActionView)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user actions

- (void)showActionView {
    UGCCommonSheetView *sheetView = [UGCCommonSheetView new];
    UGCCommonSheetViewItem *item1 = [UGCCommonSheetViewItem actionWithTitle:@"清除缓存" subTitle:nil style:UGCCommonSheetViewItemStyleDefault handler:^(UGCCommonSheetViewItem *viewItem) {
        [self clearLocalCache];
    }];
    [sheetView addActionItem:item1];
    
    UGCCommonSheetViewItem *item2 = [UGCCommonSheetViewItem actionWithTitle:@"是否开启淡入淡出效果" subTitle:[NSString stringWithFormat:@"当前状态：%@", self.enableFadeEffect?@"开启":@"关闭"] style:UGCCommonSheetViewItemStyleDefault handler:^(UGCCommonSheetViewItem *viewItem) {
        self.enableFadeEffect = !self.enableFadeEffect;
    }];
    [sheetView addActionItem:item2];
    
    UGCCommonSheetViewItem *item3 = [UGCCommonSheetViewItem actionWithTitle:@"是否启用加载图" subTitle:[NSString stringWithFormat:@"当前状态：%@ 下个状态：%@", [self hintMapToLoadingFrame:self.loadingFrame], [self hintMapToLoadingFrame:(self.loadingFrame + 1) % 3]] style:UGCCommonSheetViewItemStyleDefault handler:^(UGCCommonSheetViewItem *viewItem) {
        self.loadingFrame = (self.loadingFrame + 1) % 3;
    }];
    [sheetView addActionItem:item3];
    
    UGCCommonSheetViewItem *item4 = [UGCCommonSheetViewItem actionWithTitle:@"取消" subTitle:nil style:UGCCommonSheetViewItemStyleCancel handler:nil];
    [sheetView addActionItem:item4];
    [sheetView show];
}

- (NSString *)hintMapToLoadingFrame:(FadeEffectCellLoadingFrame)frame {
    NSString *hintText = nil;
    switch (frame) {
        case FadeEffectCellLoadingFrameNone:
        {
                hintText = @"不启用加载图";
        }
            break;
        case FadeEffectCellLoadingFramePic:
        {
            hintText = @"启用加载图";
        }
            break;
        case FadeEffectCellLoadingFrameCustomView:
        {
            hintText = @"启用自定义加载视图";
        }
            break;
        default:
            break;
    }
    return hintText;
}

#pragma mark - private methods

- (void)clearLocalCache {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.picUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewBaseFadeEffectCell *cell = [tableView dequeueReusableCellWithIdentifier:[ImageViewBaseFadeEffectCell cellIdentifier]];
    if (!cell) {
        cell = [[ImageViewBaseFadeEffectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ImageViewBaseFadeEffectCell cellIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.enableFadeEffect = self.enableFadeEffect;
    cell.loadingStyle = self.loadingFrame;
    cell.picUrl = [NSURL URLWithString:self.picUrls[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

@end
