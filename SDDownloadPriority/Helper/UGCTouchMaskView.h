//
//  UGCTouchMaskView.h
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/1.
//  Copyright © 2018年 welson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UGCTouchMaskState) {
    UGCTouchMaskStateBegin,
    UGCTouchMaskStateMove,
    UGCTouchMaskStateEnd,
    UGCTouchMaskStateCancel
};

@interface UGCTouchMaskView : UIView

@property (nonatomic, copy) void (^stateDidChanged)(NSSet<UITouch *> *, UIEvent *, UGCTouchMaskState state);

@end
