//
//  NVLinearLayoutContainer.m
//  Pods
//
//  Created by 纪鹏 on 2016/10/31.
//
//

#import "NVLayoutContainer.h"
#import "UIView+Layout.h"
#import "UIView+NVLinearLayout.h"
#import <objc/runtime.h>
#import "UIScreen+Adaptive.h"

static const void *NVLinearLayoutKey_placeHolderView = @"NVLinearLayoutKey_placeHolderView";

@interface UIView (NVContainerPlaceHolderView)
@property (nonatomic, assign) BOOL isPlaceHolderView;
@end

@implementation UIView (NVContainerPlaceHolderView)
- (void)setIsPlaceHolderView:(BOOL)isPlaceHolderView {
    objc_setAssociatedObject(self, NVLinearLayoutKey_placeHolderView, @(isPlaceHolderView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isPlaceHolderView {
    NSNumber * placeHolderView = (NSNumber *)objc_getAssociatedObject(self, NVLinearLayoutKey_placeHolderView);
    if (!placeHolderView) {
        return NO;
    } else {
        return [placeHolderView boolValue];
    }
}
@end

@interface NVLayoutContainer ()
@property (nonatomic, strong) NSArray * containerViews;
@end

@implementation NVLayoutContainer

+ (instancetype)containerViews:(UIView *)subview, ...{
    va_list args;
    va_start(args, subview);
    NVLayoutContainer *instance = [[self alloc] initWithFirstView:subview vaList:args];
    va_end(args);
    return instance;
}

+ (instancetype)containerViewArray:(NSArray<UIView *> *)subviewArray {
    return  [[self alloc] initWithViewArray:subviewArray];
}

+ (UIView *)placeHolderView {
    UIView * placeHolderView = [UIView new];
    placeHolderView.isPlaceHolderView = YES;
    placeHolderView.width = [UIScreen width];
    placeHolderView.height = CGFLOAT_MIN;
    //优先级最低
    placeHolderView.showPriority = 0;
    return placeHolderView;
}

- (instancetype)initWithFirstView:(UIView *)subview vaList:(va_list)args {
    if (self = [super init]) {
        NSMutableArray * array = [NSMutableArray new];
        for (UIView *arg = subview; arg != nil; arg = va_arg(args, UIView *)) {
            [array addObject:arg];
        }
        
        _containerViews = (id)array;
        _horizontalAlignment = NVLayoutHorizontalAlignmentLeft;
        _verticalAlignment = NVLayoutVerticalAlignmentBottom;
        _baseLineAlignment = YES;
    }
    return self;
}

- (instancetype)initWithViewArray:(NSArray<UIView *> *)subviewArray {
    if (self = [super init]) {
        _containerViews = subviewArray;
        _horizontalAlignment = NVLayoutHorizontalAlignmentLeft;
        _verticalAlignment = NVLayoutVerticalAlignmentBottom;
        _baseLineAlignment = YES;
    }
    return self;
}

- (instancetype)init {
    return [self initWithFirstView:nil vaList:nil];
}

- (NSArray <UIView *> *)subviews {
    NSMutableArray * array = [NSMutableArray new];
    for (UIView * view in self.containerViews) {
        if (!view.isPlaceHolderView) {
            [array addObject:view];
        }
    }
    return [array copy];
}

- (NSArray <UIView *> *)visibleViews {
    NSMutableArray<UIView *>  *subviewArr = [NSMutableArray new];
    for (UIView *view in self.containerViews) {
        if (!view.hidden) {
            [subviewArr addObject:view];
        }
    }
    return [subviewArr copy];
}

- (void)insertLastSubview:(UIView *)view {
    if (view == nil || view.hidden || view.width <= CGFLOAT_MIN) {
        return;
    }
    self.containerViews = [self.containerViews arrayByAddingObjectsFromArray:@[view]];
    [self preComputeSubviewsSize];
    [self sizeToFit];
    [self layout];
}

- (void)sizeToFit {
    self.width = [self widthWrapContent];
    self.height = [self heightWrapContent];
}

- (CGFloat)widthWrapContent {
    NSArray<UIView *> *subviewArr = [self visibleViews];
    CGFloat width = 0;
    
    if (self.horizontalAlignment == NVLayoutHorizontalAlignmentCenter || self.horizontalAlignment == NVLayoutHorizontalAlignmentRight) {
        for (UIView *view in subviewArr) {
            width += view.width;
            if (view == subviewArr.lastObject) {
                width += (view.marginRight > CGFLOAT_MIN ? view.marginRight : 0);
            } else {
                width += (view.marginRight > CGFLOAT_MIN ? view.marginRight : self.divideSpace);
            }
        }
    } else {
        for (UIView *view in subviewArr) {
            width += view.width;
            if (view == subviewArr.firstObject) {
                width += (view.marginLeft > CGFLOAT_MIN ? view.marginLeft : 0);
            } else {
                width += (view.marginLeft > CGFLOAT_MIN ? view.marginLeft : self.divideSpace);
            }
        }
    }
    return width;
}

- (CGFloat)heightWrapContent {
    NSArray<UIView *> *subviewArr = [self visibleViews];
    
    CGFloat height = 0;
    for (UIView *view in subviewArr) {
        CGFloat maxHeight = view.height + view.marginTop + view.marginBottom;
        height = MAX(height, maxHeight);
    }
    return height;
}

- (NSArray<NSNumber *> *)priorityArray:(NSArray<UIView *> *)views {
    NSMutableArray * array = [NSMutableArray new];
    for (UIView * view in views) {
        [array addObject:@(view.showPriority)];
    }
    return [array copy];
}

- (void)preComputeSubviewsSize {
    if (self.maxShowWidth <= CGFLOAT_MIN) {
        return;
    }
    
    NSArray * subViews = [self visibleViews];
    
    NSSet * prioritySet = [NSSet setWithArray:[self priorityArray:subViews]];
    if (prioritySet.count != subViews.count) {
        //添加默认的优先级
        for (UIView * view in self.containerViews) {
            if (!view.isPlaceHolderView) {
                view.showPriority = [subViews indexOfObject:view] + 1;
            }
        }
    }
    
    NSArray<UIView *> * visibleSubviews = [self visibleViews];
    NSArray<UIView *> * sortedArray =[visibleSubviews sortedArrayUsingComparator:^NSComparisonResult(UIView * obj1, UIView * obj2) {
        //按showPriority从大到小排队
        return obj1.showPriority < obj2.showPriority;
    }];
    
    CGFloat totalWith = 0;
    UIView * cutView = nil;
    UIView * hiddenView = nil;
    
    for (UIView * view in sortedArray) {
        CGFloat space = 0;
        if (self.horizontalAlignment == NVLayoutVerticalAlignmentCenter || self.horizontalAlignment == NVLayoutHorizontalAlignmentRight) {
            if (view == subViews.lastObject) {
                space = (view.marginRight > CGFLOAT_MIN ? view.marginRight : 0);
            } else {
                space = (view.marginRight > CGFLOAT_MIN ? view.marginRight : self.divideSpace);
            }
        } else {
            if (view == subViews.firstObject) {
                space = (view.marginLeft > CGFLOAT_MIN ? view.marginLeft : 0);
            } else {
                space = (view.marginLeft > CGFLOAT_MIN ? view.marginLeft : self.divideSpace);
            }
        }
        totalWith += space;
        if (totalWith >= self.maxShowWidth) {
            hiddenView = view;
            break;
        }
        totalWith += view.width;
        if (totalWith >= self.maxShowWidth) {
            if (view.unableCutOff) {
                hiddenView = view;
            } else {
                cutView = view;
            }
            break;
        }
    }
    
    NSArray * hiddenArray = nil;
    if (hiddenView) {
        NSInteger index = [sortedArray indexOfObject:hiddenView];
        hiddenArray = [sortedArray subarrayWithRange:NSMakeRange(index, sortedArray.count - index)];
    }
    if (cutView) {
        NSInteger index = [sortedArray indexOfObject:cutView];
        cutView.width = cutView.width - (totalWith - self.maxShowWidth);
        hiddenArray = [sortedArray subarrayWithRange:NSMakeRange(index + 1, sortedArray.count - (index + 1))];
    }
    for (UIView * view in hiddenArray) {
        view.hidden = YES;
    }
}

- (void)layout {
    NSArray<UIView *>  *subviewArr = [self visibleViews];
    
    CGFloat leftAnchor = self.left;
    if (self.horizontalAlignment == NVLayoutHorizontalAlignmentRight || self.horizontalAlignment == NVLayoutHorizontalAlignmentCenter) {
        CGFloat totalViewWidth = [self widthWrapContent];
        if (self.horizontalAlignment == NVLayoutHorizontalAlignmentRight) {
            leftAnchor += self.width - totalViewWidth;
        } else {
            leftAnchor += (self.width - totalViewWidth) / 2;
        }
    }
    
    if (self.horizontalAlignment == NVLayoutHorizontalAlignmentRight || self.horizontalAlignment ==
        NVLayoutVerticalAlignmentCenter) {
        for (UIView *view in subviewArr) {
            view.left = leftAnchor;
            BOOL hasMarginRight = view.marginRight > CGFLOAT_MIN;
            CGFloat space = hasMarginRight ? view.marginRight : (view == subviewArr.lastObject ? 0 : self.divideSpace);
            leftAnchor = view.right + space;
        }
    } else {
        for (UIView *view in subviewArr) {
            BOOL hasMarginLeft = view.marginLeft > CGFLOAT_MIN;
            CGFloat space = (hasMarginLeft ? view.marginLeft : (view == subviewArr.firstObject ? 0 : self.divideSpace));
            view.left = leftAnchor + space;
            leftAnchor = view.right;
        }
    }
    
    for (UIView *view in subviewArr) {
        if (self.verticalAlignment == NVLayoutVerticalAlignmentTop) {
            view.top = self.top + (view.marginTop <= CGFLOAT_MIN ? 0 : view.marginTop);
        } else if (self.verticalAlignment == NVLayoutVerticalAlignmentBottom){
            view.bottom = self.top + self.height - (view.marginBottom <= CGFLOAT_MIN ? 0 : view.marginBottom);
        } else {
            view.centerY = self.centerY;
        }
        if (self.baseLineAlignment && !view.ignoreBaselineAdjustment) {
            view.baseLine = view.bottom;
        }
    }
}

- (void)autoLayout {
    [self preComputeSubviewsSize];
    [self sizeToFit];
    [self layout];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect rect = self.frame;
    rect.origin.x = right - self.frame.size.width;
    self.frame = rect;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect rect = self.frame;
    rect.origin.y = bottom - self.frame.size.height;
    self.frame = rect;
}

- (CGFloat)centerX {
    return self.left + self.width / 2;
}

- (void)setCenterX:(CGFloat)centerX {
    self.left = centerX - self.width / 2;
}

- (CGFloat)centerY {
    return self.top + self.height / 2;
}

- (void)setCenterY:(CGFloat)centerY {
    self.top = centerY - self.height / 2;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize) size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

