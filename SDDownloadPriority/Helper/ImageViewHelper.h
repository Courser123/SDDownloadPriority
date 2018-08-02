//
//  ImageViewHelper.h
//  ImageViewBase_Example
//
//  Created by welson on 2018/2/28.
//  Copyright © 2018年 welson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageViewHelper : NSObject

/**
 *  用于测试的URL链接，不含重复的URL
 *
 */
+ (NSArray<NSString *> *)remoteUrlList;

/**
 *  返回本地静态PNG小图
 *
 */
+ (UIImage *)smallLocalPNGImage;

/**
 *  返回本地静态PNG Data
 *
 */
+ (NSData *)smallLocalPNGImageData;

/**
 * 返回本地静态JPG小图
 */
+ (UIImage *)smallLocalJPGImage;

/**
 * 返回本地静态JPG Data
 */
+ (NSData *)smallLocalJPGImageData;

/**
 * 返回本地带Alpha通道的PNG图
 */
+ (UIImage *)localPNGImageWithAlpha;

/**
 * 返回本地带Alpha通道的PNG Data
 */
+ (NSData *)localPNGDataWithAlpha;

/**
 * 返回本地静态webp Data
 */
+ (NSData *)staticWebpImageData;

/**
 * 返回本地动态webp Data
 */
+ (NSData *)animatedWebpImageData;

/**
 * 返回本地GIF Data
 */
+ (NSData *)smallLocalGif;

@end
