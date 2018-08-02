//
//  UIScrollView+Adaptive.h
//  Nova
//
//  Created by bohui.xie on 2017/10/17.
//  Copyright © 2017年 dianping.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NVScrollViewContentInsetAdjustmentBehavior) {
    NVScrollViewContentInsetAdjustmentAutomatic, // Similar to .scrollableAxes, but for backward compatibility will also adjust the top & bottom contentInset when the scroll view is owned by a view controller with automaticallyAdjustsScrollViewInsets = YES inside a navigation controller, regardless of whether the scroll view is scrollable
    NVScrollViewContentInsetAdjustmentScrollableAxes, // Edges for scrollable axes are adjusted (i.e., contentSize.width/height > frame.size.width/height or alwaysBounceHorizontal/Vertical = YES)
    NVScrollViewContentInsetAdjustmentNever, // contentInset is not adjusted
    NVScrollViewContentInsetAdjustmentAlways, // contentInset is always adjusted by the scroll view's safeAreaInsets
};

@interface UIScrollView (Adaptive)

@property (nonatomic, assign) NVScrollViewContentInsetAdjustmentBehavior nvContentInsetAdjustmentBehavior;

@end
