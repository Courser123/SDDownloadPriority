//
//  ImageViewBaseViewController.m
//  ImageViewBase
//
//  Created by welson on 02/27/2018.
//  Copyright (c) 2018 welson. All rights reserved.
//

#import "ImageViewBaseViewController.h"
#import "ImageViewHelper.h"

@interface ImageViewBaseViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *source;

@end

@implementation ImageViewBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self preCheckMethod];
    
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.source = @{
                    @"淡入淡出"         :@"ImageViewBaseFadeEffectViewController",
                    @"动图播放"         :@"ImageViewBaseAnimatedPhotoViewController",
                    @"瀑布流 视觉"       :@"ImageViewBaseWaterFallViewController"
                    };
}

- (void)preCheckMethod {
    if (![self existURLsForTest]) NSAssert(NO, @"not exist image urls for test!");
    if (![self existAvatarImage]) NSAssert(NO, @"not exist Avatar image for test!");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.source.allKeys[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *vcName = [self.source objectForKey:self.source.allKeys[indexPath.row]];
    if (!vcName.length) return;
    if (!NSClassFromString(vcName)) return;
    id vc = [[NSClassFromString(vcName) alloc] init];
    if (![vc isKindOfClass:[UIViewController class]]) return;
    ((UIViewController *)vc).title = self.source.allKeys[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - test

- (BOOL)existURLsForTest {
    return [ImageViewHelper remoteUrlList].count;
}

- (BOOL)existAvatarImage {
    return [ImageViewHelper smallLocalPNGImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
