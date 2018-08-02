//
//  ImageViewBaseFadeEffectCell.m
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/1.
//  Copyright © 2018年 welson. All rights reserved.
//

#import "ImageViewBaseFadeEffectCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Layout.h"
#import "NVDefaultPlaceHolderView.h"

@interface ImageViewBaseFadeEffectCell()

@property (nonatomic, strong) UIImageView *picassoImageView;
@property (nonatomic, strong) NVDefaultPlaceHolderView *placeholderView;

@end

@implementation ImageViewBaseFadeEffectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _picassoImageView = [UIImageView new];
        _picassoImageView.clipsToBounds = YES;
        _picassoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picassoImageView.sd_disableFadeEffect = NO;
        [self.contentView addSubview:_picassoImageView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.picassoImageView.image = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftPadding = 15;
    self.picassoImageView.width = self.width - leftPadding * 2;
    self.picassoImageView.height = self.height;
    self.picassoImageView.left = leftPadding;
}

- (void)setLoadingStyle:(FadeEffectCellLoadingFrame)loadingStyle {
    _loadingStyle = loadingStyle;
    switch (loadingStyle) {
        case FadeEffectCellLoadingFrameNone:
        {
//            self.picassoImageView.loadingImage = nil;
        }
            break;
        case FadeEffectCellLoadingFramePic:
        {
//            self.picassoImageView.loadingImage = [UIImage imageNamed:@"loadingPicFrame"];
        }
            break;
        case FadeEffectCellLoadingFrameCustomView:
        {
//            self.picassoImageView.placeHolderView = self.placeholderView;
        }
            break;
        default:
            break;
    }
}

#pragma mark - properties

- (void)setPicUrl:(NSURL *)picUrl {
    _picUrl = picUrl;
    [self.picassoImageView sd_setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"loadingPicFrame"]];
}

- (void)setEnableFadeEffect:(BOOL)enableFadeEffect {
    _enableFadeEffect = enableFadeEffect;
}

+ (NSString *)cellIdentifier {
    return @"ImageViewBaseFadeEffectCell";
}

@end
