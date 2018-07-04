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

@end
