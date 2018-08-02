//
//  ImageViewBaseFadeEffectCell.h
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/1.
//  Copyright © 2018年 welson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FadeEffectCellLoadingFrame) {
    FadeEffectCellLoadingFrameNone,
    FadeEffectCellLoadingFramePic,
    FadeEffectCellLoadingFrameCustomView,
};

@interface ImageViewBaseFadeEffectCell : UITableViewCell

@property (nonatomic, strong) NSURL *picUrl;
@property (nonatomic, assign) FadeEffectCellLoadingFrame loadingStyle;
@property (nonatomic, assign) BOOL enableFadeEffect;

+ (NSString *)cellIdentifier;

@end
