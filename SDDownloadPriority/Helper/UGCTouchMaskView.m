//
//  UGCTouchMaskView.m
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/1.
//  Copyright © 2018年 welson. All rights reserved.
//

#import "UGCTouchMaskView.h"

@implementation UGCTouchMaskView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.stateDidChanged) self.stateDidChanged(touches, event, UGCTouchMaskStateBegin);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.stateDidChanged) self.stateDidChanged(touches, event, UGCTouchMaskStateEnd);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.stateDidChanged) self.stateDidChanged(touches, event, UGCTouchMaskStateMove);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.stateDidChanged) self.stateDidChanged(touches, event, UGCTouchMaskStateCancel);
}

@end
