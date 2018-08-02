//
//  UILabel+baseLine.m
//  Pods
//
//  Created by 纪鹏 on 2016/11/11.
//
//

#import "UILabel+BaseLine.h"
#import "UIView+Layout.h"

@implementation UILabel (BaseLine)

- (CGFloat)baseLine {
    return self.bottom - [self baseLineBottomOffset];
}

- (void)setBaseLine:(CGFloat)baseLine {
    self.bottom = baseLine + [self baseLineBottomOffset];
}

- (CGFloat)baseLineBottomOffset {
    if (self.numberOfLines >= 2) {
        return 0;
    } else {
        __block UIFont *maxFont = [UIFont systemFontOfSize:1];
        [self.attributedText enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(UIFont *value, NSRange range, BOOL * _Nonnull stop) {
            if (value.pointSize > maxFont.pointSize) {
                maxFont = value;
            }
        }];
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat bottomOffset = (floor(-maxFont.descender * scale) - 1) / scale;
        if ([self isContainChinese:self.text]) {
            CGFloat tunning = 0;
            if (maxFont.pointSize <= 8) {
                tunning = 2;
            } else if (maxFont.pointSize <= 23) {
                tunning = floor((maxFont.pointSize + 1) / 5);
            } else if (maxFont.pointSize <= 30) {
                tunning = 6;
            } else if (maxFont.pointSize <= 35) {
                tunning = 7;
            } else {
                tunning = 8;
            }
            bottomOffset -= tunning/scale;
        }
        bottomOffset += (self.height - ceil(maxFont.lineHeight * scale) / scale ) / 2;
        return bottomOffset;
    }
}

- (BOOL)isContainChinese:(NSString *)string {
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

@end
