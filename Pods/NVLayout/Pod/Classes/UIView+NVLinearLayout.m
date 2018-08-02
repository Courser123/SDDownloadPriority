//
//  UIView+LinearLayout.m
//  Pods
//
//  Created by 纪鹏 on 2016/10/21.
//
//

#import "UIView+NVLinearLayout.h"
#import <objc/runtime.h>

static const void *NVLinearLayoutKey_marginLeft = @"NVLinearLayoutKey_marginLeft";
static const void *NVLinearLayoutKey_marginBottom = @"NVLinearLayoutKey_marginBottom";
static const void *NVLinearLayoutKey_marginTop = @"NVLinearLayoutKey_marginTop";
static const void *NVLinearLayoutKey_marginRight = @"NVLinearLayoutKey_marginRight";
static const void *NVLinearLayoutKey_ignoreBaselineAdjustment = @"NVLinearLayoutKey_ignoreBaselineAdjustment";

static const void *NVLayoutContainer_showPriority = @"NVLayoutContainer_showPriority";
static const void *NVLayoutContainer_unableCutOff = @"NVLayoutContainer_unableCutOff";

@implementation UIView (NVLinearLayout)
@dynamic marginLeft;
@dynamic marginBottom;
@dynamic marginTop;
@dynamic marginRight;

- (CGFloat) marginLeft {
    NSNumber *marginLeftNum = (NSNumber *)objc_getAssociatedObject(self, NVLinearLayoutKey_marginLeft);
    if (!marginLeftNum) {
        return CGFLOAT_MIN;
    } else {
        return [marginLeftNum floatValue];
    }
}

- (void)setMarginLeft:(CGFloat)marginLeft {
    objc_setAssociatedObject(self, NVLinearLayoutKey_marginLeft, @(marginLeft), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat) marginRight {
    NSNumber *marginRightNum = (NSNumber *)objc_getAssociatedObject(self, NVLinearLayoutKey_marginRight);
    if (!marginRightNum) {
        return CGFLOAT_MIN;
    } else {
        return [marginRightNum floatValue];
    }
}

- (void)setMarginRight:(CGFloat)marginRight {
    objc_setAssociatedObject(self, NVLinearLayoutKey_marginRight, @(marginRight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat) marginTop {
    NSNumber *marginTopNum = (NSNumber *)objc_getAssociatedObject(self, NVLinearLayoutKey_marginTop);
    if (!marginTopNum) {
        return CGFLOAT_MIN;
    } else {
        return [marginTopNum floatValue];
    }
}

- (void)setMarginTop:(CGFloat)marginTop {
    objc_setAssociatedObject(self, NVLinearLayoutKey_marginTop, @(marginTop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat) marginBottom {
    NSNumber *marginBottomNum = (NSNumber *)objc_getAssociatedObject(self, NVLinearLayoutKey_marginBottom);
    if (!marginBottomNum) {
        return CGFLOAT_MIN;
    } else {
        return [marginBottomNum floatValue];
    }
}

- (void)setMarginBottom:(CGFloat)marginBottom {
    objc_setAssociatedObject(self, NVLinearLayoutKey_marginBottom, @(marginBottom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL) ignoreBaselineAdjustment {
    return [(NSNumber *)objc_getAssociatedObject(self, NVLinearLayoutKey_ignoreBaselineAdjustment) boolValue];
}

- (void)setIgnoreBaselineAdjustment:(BOOL)ignoreBaselineAdjustment {
    objc_setAssociatedObject(self, NVLinearLayoutKey_ignoreBaselineAdjustment, @(ignoreBaselineAdjustment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)showPriority {
    NSNumber * showPriority = (NSNumber *)objc_getAssociatedObject(self, NVLayoutContainer_showPriority);
    if (!showPriority) {
        return CGFLOAT_MIN;
    } else {
        return [showPriority integerValue];
    }
}

- (void)setShowPriority:(NSInteger)showPriority {
    objc_setAssociatedObject(self, NVLayoutContainer_showPriority, @(showPriority), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)unableCutOff {
    NSNumber * unableCutOff = (NSNumber *)objc_getAssociatedObject(self, NVLayoutContainer_unableCutOff);
    if (!unableCutOff) {
        return NO;
    } else {
        return [unableCutOff boolValue];
    }
}

- (void)setUnableCutOff:(BOOL)unableCutOff {
    objc_setAssociatedObject(self, NVLayoutContainer_unableCutOff, @(unableCutOff), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
