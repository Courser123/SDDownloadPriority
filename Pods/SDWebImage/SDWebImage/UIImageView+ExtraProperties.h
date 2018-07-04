//
//  UIImageView+ExtraProperties.h
//  Pods
//
//  Created by welson on 2018/2/23.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ExtraProperties)

/**
 *  默认加载图
 *  加载图的优先级关系   接口设置的placeholder > loadingImage > 点评默认加载图
 */
@property (nonatomic, strong) UIImage *dp_loadingImage;

/**
 *  下载失败默认图
 *  当下载失败的时候并且errorImage非空时，默认会设置这张图片
 */
@property (nonatomic, strong) UIImage *dp_errorImage;

/**
 *  默认空态图
 *  当成功下载数据，但是数据并不是一张图片时，会展示这张默认图
 */
@property (nonatomic, strong) UIImage *dp_emptyImage;

@end
