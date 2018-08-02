//
//  ImageViewHelper.m
//  ImageViewBase_Example
//
//  Created by welson on 2018/2/28.
//  Copyright © 2018年 welson. All rights reserved.
//

#import "ImageViewHelper.h"

@implementation ImageViewHelper

+ (NSArray<NSString *> *)remoteUrlList {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"remoteUrls" ofType:@"txt"];
    NSSet *set = [NSSet setWithArray:[self parsedUrlListWithFileName:fileName]];
    return [NSArray arrayWithArray:[set allObjects]];
}

+ (NSArray<NSString *> *)parsedUrlListWithFileName:(NSString *)fileName {
    if (!fileName.length) return nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileName]) return nil;
    NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [str componentsSeparatedByString:@","];
}

+ (UIImage *)smallLocalPNGImage {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"avatar@2x" ofType:@"png"];
    if (!fileName.length) return nil;
    UIImage *avatar = [[UIImage alloc] initWithContentsOfFile:fileName];
    return avatar;
}

+ (NSData *)smallLocalPNGImageData {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"avatar@2x" ofType:@"png"];
    if (!fileName.length) return nil;
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:fileName];
    return data;
}

+ (UIImage *)smallLocalJPGImage {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"jpg"];
    if (!fileName.length) return nil;
    UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:fileName];
    return testImage;
}

+ (NSData *)smallLocalJPGImageData {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"jpg"];
    if (!fileName.length) return nil;
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:fileName];
    return data;
}

+ (UIImage *)localPNGImageWithAlpha {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"png"];
    if (!fileName.length) return nil;
    UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:fileName];
    return testImage;
}

+ (NSData *)localPNGDataWithAlpha {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"png"];
    if (!fileName.length) return nil;
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:fileName];
    return data;
}

+ (NSData *)staticWebpImageData {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"TestImageStatic" ofType:@"webp"];
    if (!fileName.length) return nil;
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:fileName];
    return data;
}

+ (NSData *)animatedWebpImageData {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"TestImageAnimated" ofType:@"webp"];
    if (!fileName.length) return nil;
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:fileName];
    return data;
}

+ (NSData *)smallLocalGif {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"smallLocalGif" ofType:@"gif"];
    if (!fileName.length) return nil;
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:fileName];
    return data;
}

@end
