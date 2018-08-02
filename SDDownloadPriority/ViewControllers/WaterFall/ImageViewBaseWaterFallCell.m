//
//  ImageViewBaseWaterFallCell.m
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/12.
//  Copyright © 2018年 welson. All rights reserved.
//

#import "ImageViewBaseWaterFallCell.h"
#import "UIImageView+WebCache.h"
#import "NVDefaultPlaceHolderView.h"

@interface ImageViewBaseWaterFallCell()

@property (nonatomic, strong) UIImageView *picassoImageView;
@end

@implementation ImageViewBaseWaterFallCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _picassoImageView = [UIImageView new];
        _picassoImageView.clipsToBounds = YES;
        _picassoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picassoImageView.sd_disableFadeEffect = NO;
        [self.contentView addSubview:_picassoImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.picassoImageView.frame = self.bounds;
}

- (void)setPicURL:(NSURL *)picURL {
    _picURL = picURL;
    [self.picassoImageView sd_setImageWithURL:picURL placeholderImage:[UIImage imageNamed:@"loadingPicFrame"]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.picassoImageView.image = nil;
}

+ (NSString *)cellIdentifier {
    return @"ImageViewBaseWaterFallCell";
}

@end
