//
//  ImageViewBaseAnimatedCell.m
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/5.
//  Copyright © 2018年 welson. All rights reserved.
//

#import "ImageViewBaseAnimatedCell.h"
#import "UIView+Layout.h"
#import "UIImageView+WebCache.h"

@interface ImageViewBaseAnimatedCell()

@property (nonatomic, strong) UIImageView *animatedImageView;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIView *controlView;

@end

@implementation ImageViewBaseAnimatedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _controlView = [UIView new];
        _controlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:_controlView];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [_controlView addSubview:_playButton];
        
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopPlay:) forControlEvents:UIControlEventTouchUpInside];
        [_controlView addSubview:_stopButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.height;
    CGFloat width = self.animatedImageView.image?self.animatedImageView.image.size.width/self.animatedImageView.image.size.height * height:height;
    CGFloat leftPadding = 15;
    self.animatedImageView.left = leftPadding;
    self.animatedImageView.width = width;
    self.animatedImageView.height = height;
    
    self.controlView.height = 50;
    self.controlView.width = width;
    self.controlView.left = self.animatedImageView.left;
    self.controlView.bottom = self.animatedImageView.bottom;
    
    self.playButton.size = self.stopButton.size = CGSizeMake(50, 50);
    self.playButton.left = leftPadding;
    self.stopButton.left = self.playButton.right;
}

- (void)setImageData:(NSData *)imageData {
    _imageData = imageData;
    
//    if (self.usePicassoImageView) {
//        [(PicassoBaseImageView *)self.animatedImageView setImageData:imageData];
//        self.playButton.selected = YES;
//    }else {
//        self.player = [[PicassoImagePlayer alloc] initWithImageData:imageData];
//        self.player.delegate = self;
//        self.player.identifier = self.identifier;
//        self.animatedImageView.image = [self.player posterImage];
//    }
    [self setNeedsLayout];
}

- (void)setUsePicassoImageView:(BOOL)usePicassoImageView {
    _usePicassoImageView = usePicassoImageView;
    if (self.animatedImageView) [self.animatedImageView removeFromSuperview];
//    self.animatedImageView = usePicassoImageView?[PicassoBaseImageView new]:[UIImageView new];
    self.animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.animatedImageView];
    [self.contentView bringSubviewToFront:self.controlView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.animatedImageView.image = nil;
}

+ (NSString *)cellIdentifier {
    return @"imageviewbaseanimatedcell";
}

+ (CGFloat)suggestHeight {
    return 216;
}

@end
