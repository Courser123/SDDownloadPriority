//
//  ImageViewBaseAnimatedPhotoViewController.m
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/2.
//  Copyright © 2018年 welson. All rights reserved.
//

#import "ImageViewBaseAnimatedPhotoViewController.h"
#import "ImageViewBaseAnimatedCell.h"

@interface ImageViewBaseAnimatedPhotoViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *source;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *cellHeight;

@end

@implementation ImageViewBaseAnimatedPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

//- (void)test {
//    PicassoBaseImageView *baseImageView = [[PicassoBaseImageView alloc] initWithFrame:self.view.bounds];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TestWebp" ofType:@"webp"];
//    [baseImageView setImageData:[NSData dataWithContentsOfFile:filePath]];
//    [self.view addSubview:baseImageView];
//}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)initData {

    self.source = @[
                    @[@"roastDuckGif", @"gif"],
                    @[@"TestWebp", @"webp"],
                    @[@"smallLocalGif", @"gif"],
                    @[@"roastDuckGif", @"gif"],
                    @[@"bdd2132ccbc42d8b2f89a7644cd99871125666.gif",@"webp"],
                    ];
    
    self.cellHeight = @{
                        @"roastDuckGif":@(196),
                        @"TestWebp":@(296)
                        };
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewBaseAnimatedCell *cell = [tableView dequeueReusableCellWithIdentifier:[ImageViewBaseAnimatedCell cellIdentifier]];
    if (!cell) {
        cell = [[ImageViewBaseAnimatedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ImageViewBaseAnimatedCell cellIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *item = self.source[indexPath.row];
    NSString *fileName = [[NSBundle mainBundle] pathForResource:item[0] ofType:item[1]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
    cell.identifier = item[0];
    cell.usePicassoImageView = YES;
    cell.imageData = data;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *item = self.source[indexPath.row];
    if (self.cellHeight[item[0]]) return [self.cellHeight[item[0]] floatValue];
    return [ImageViewBaseAnimatedCell suggestHeight];
}




@end
