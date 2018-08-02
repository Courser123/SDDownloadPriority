//
//  ImageViewBaseWaterFallViewController.m
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/12.
//  Copyright © 2018年 welson. All rights reserved.
//

#import "ImageViewBaseWaterFallViewController.h"
#import "ImageViewHelper.h"
#import "ImageViewBaseWaterFallCell.h"
#import "UIView+Layout.h"
#import "UGCCommonSheetView.h"
#import "SDImageCache.h"

@interface ImageViewBaseWaterFallViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *URLs;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger countPerRow;

@end

@implementation ImageViewBaseWaterFallViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = layout.minimumLineSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ImageViewBaseWaterFallCell class] forCellWithReuseIdentifier:[ImageViewBaseWaterFallCell cellIdentifier]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showActionView)];
}

- (void)initData {
    self.URLs = [ImageViewHelper remoteUrlList];
    self.countPerRow = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearLocalCache {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark - collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.URLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewBaseWaterFallCell *cell = (ImageViewBaseWaterFallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[ImageViewBaseWaterFallCell cellIdentifier] forIndexPath:indexPath];
    cell.picURL = [NSURL URLWithString:self.URLs[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat edgePadding = 10, itemPadding = 10;
    CGFloat validWidth = self.view.width - edgePadding * 2;
    CGFloat itemWidth = floor((validWidth - (self.countPerRow - 1) * itemPadding) / self.countPerRow);
    return CGSizeMake(itemWidth, itemWidth);
}

- (void)showActionView {
    UGCCommonSheetView *sheetView = [UGCCommonSheetView new];
    UGCCommonSheetViewItem *item1 = [UGCCommonSheetViewItem actionWithTitle:@"清除缓存" subTitle:nil style:UGCCommonSheetViewItemStyleDefault handler:^(UGCCommonSheetViewItem *viewItem) {
        [self clearLocalCache];
    }];
    [sheetView addActionItem:item1];
    
    UGCCommonSheetViewItem *item2 = [UGCCommonSheetViewItem actionWithTitle:@"一行4个" subTitle:nil style:UGCCommonSheetViewItemStyleDefault handler:^(UGCCommonSheetViewItem *viewItem) {
        self.countPerRow = 4;
        [self.collectionView reloadData];
    }];
    [sheetView addActionItem:item2];
    
    UGCCommonSheetViewItem *item3 = [UGCCommonSheetViewItem actionWithTitle:@"一行8个" subTitle:nil style:UGCCommonSheetViewItemStyleDefault handler:^(UGCCommonSheetViewItem *viewItem) {
        self.countPerRow = 8;
        [self.collectionView reloadData];
    }];
    [sheetView addActionItem:item3];
    
    UGCCommonSheetViewItem *item5 = [UGCCommonSheetViewItem actionWithTitle:@"取消" subTitle:nil style:UGCCommonSheetViewItemStyleCancel handler:nil];
    [sheetView addActionItem:item5];
    [sheetView show];
}

@end
