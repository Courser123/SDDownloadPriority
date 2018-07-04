//
//  UIImageView+ExtraProperties.m
//  Pods
//
//  Created by welson on 2018/2/23.
//

#import "UIImageView+ExtraProperties.h"
#import <objc/runtime.h>

static char dp_loadingImageKey;
static char dp_emptyImageKey;
static char dp_errorImageKey;

@implementation UIImageView (ExtraProperties)

- (void)setDp_loadingImage:(UIImage *)dp_loadingImage {
    objc_setAssociatedObject(self, &dp_loadingImageKey, dp_loadingImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)dp_loadingImage {
    return objc_getAssociatedObject(self, &dp_loadingImageKey);
}

- (void)setDp_emptyImage:(UIImage *)dp_emptyImage {
    objc_setAssociatedObject(self, &dp_emptyImageKey, dp_emptyImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)dp_emptyImage {
    return objc_getAssociatedObject(self, &dp_emptyImageKey);
}

- (void)setDp_errorImage:(UIImage *)dp_errorImage {
    objc_setAssociatedObject(self, &dp_errorImageKey, dp_errorImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)dp_errorImage {
    return objc_getAssociatedObject(self, &dp_errorImageKey);
}

@end
