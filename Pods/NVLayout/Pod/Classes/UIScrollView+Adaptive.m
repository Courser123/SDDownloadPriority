//
//  UIScrollView+Adaptive.m
//  Nova
//
//  Created by bohui.xie on 2017/10/17.
//  Copyright © 2017年 dianping.com. All rights reserved.
//

#import "UIScrollView+Adaptive.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"

@implementation UIScrollView (Adaptive)

- (void)setNvContentInsetAdjustmentBehavior:(NVScrollViewContentInsetAdjustmentBehavior)nvContentInsetAdjustmentBehavior {
    if (@available(iOS 11,*)) {
        self.contentInsetAdjustmentBehavior = (UIScrollViewContentInsetAdjustmentBehavior)nvContentInsetAdjustmentBehavior;
    }
}

- (NVScrollViewContentInsetAdjustmentBehavior)nvContentInsetAdjustmentBehavior {
    if (@available(iOS 11,*)) {
        return (NVScrollViewContentInsetAdjustmentBehavior)self.contentInsetAdjustmentBehavior;
    }
    else {
        return 0;
    }
}

@end

#pragma clang diagnostic pop
