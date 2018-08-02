//
//  UIView+LinearLayout.h
//  Pods
//
//  Created by 纪鹏 on 2016/10/21.
//
//

#import <UIKit/UIKit.h>

@interface UIView (NVLinearLayout)

@property (nonatomic) CGFloat marginLeft;
@property (nonatomic) CGFloat marginRight;
@property (nonatomic) CGFloat marginTop;
@property (nonatomic) CGFloat marginBottom;

@property (nonatomic) BOOL ignoreBaselineAdjustment;

@property (nonatomic, assign) NSInteger showPriority;
@property (nonatomic, assign) BOOL unableCutOff;

@end
