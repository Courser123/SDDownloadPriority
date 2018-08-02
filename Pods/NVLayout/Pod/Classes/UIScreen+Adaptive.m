//
//  UIScreen+Adaptive.m
//  Nova
//
//  Created by dawei on 9/28/14.
//  Copyright (c) 2014 dianping.com. All rights reserved.
//


@implementation UIScreen (Adaptive)

+ (BOOL)iPhoneX {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && (NSInteger)[UIScreen mainScreen].nativeBounds.size.height == 2436;
}

+ (CGFloat)width {
    return [self mainScreen].bounds.size.width;
}

+ (CGFloat)height {
    return [self mainScreen].bounds.size.height;
}

+ (CGFloat)scale {
    return [self width] / 320.0f;
}

+ (CGFloat)statusBarHeight {
    return [self iPhoneX] ? 44 : 20;
}

+ (CGFloat)statusBarMargin {
    return [self iPhoneX] ? 14 : 20;
}

+ (CGFloat)sensorHeight {
    return [self iPhoneX] ? 30 : 0;
}

+ (CGFloat)homeIndicatorHeight {
    return [self iPhoneX] ? 34 : 0;
}

+ (CGFloat)homeIndicatorWidth {
    return [self homeIndicatorRight] - [self homeIndicatorLeft];
}

+ (CGFloat)homeIndicatorLeft {
    return [self iPhoneX] ? 34 : 0;
}

+ (CGFloat)homeIndicatorRight {
    return [self iPhoneX] ? [self width] - 34 : [self width];
}

@end
