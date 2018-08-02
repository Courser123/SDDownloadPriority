//
//  NVMultiContainerCarrier.m
//  NVLayout
//
//  Created by David on 2017/11/23.
//

#import "NVMultiContainerCarrier.h"
#import "NVLayoutContainer.h"
#import "UIView+Layout.h"

@interface NVMultiContainerCarrier()
@property (nonatomic, strong) NSArray<NVLayoutContainer *> * containers;
@end

@implementation NVMultiContainerCarrier

+ (instancetype)carrierWithContainer:(NSArray<NVLayoutContainer *> *)containers {
    return [[self alloc] initWithContainers:containers];
}

- (instancetype)initWithContainers:(NSArray<NVLayoutContainer *> *)containers {
    if (self = [super init]) {
        _containers = containers;
    }
    return self;
}

- (BOOL)validLayoutContainer:(NVLayoutContainer *)container {
    BOOL valid = false;
    for (UIView * view in container.subviews) {
        if ((!view.hidden) && (view.width != CGFLOAT_MIN)) {
            valid = true;
            break;
        }
    }
    return valid;
}

- (NSArray<NVLayoutContainer *> *)visiableContainers {
    NSMutableArray<NVLayoutContainer *> * containers = [NSMutableArray new];
    for (NVLayoutContainer * container in self.containers) {
        if ([self validLayoutContainer:container]) {
            [containers addObject:container];
        }
    }
    return containers;
}

- (void)sizeToFit {
    self.width = [self widthWrapContent];
    self.height = [self heightWrapContent];
}

- (CGFloat)heightWrapContent {
    return self.showHeight;
}

- (CGFloat)widthWrapContent {
    CGFloat width = 0;
    for (NVLayoutContainer * container in [self visiableContainers]) {
        width = MAX(container.width, width);
    }
    return width;
}

- (NSArray<NVLayoutContainer *> *)validSubContainers {
    return [self visiableContainers];
}

- (void)layout {
    NSArray<NVLayoutContainer *> * containers = [self validSubContainers];
    CGFloat totalHeight = 0;
    for (NVLayoutContainer * container in containers) {
        totalHeight += container.height;
    }
    if (totalHeight > self.showHeight) {
        return;
    }
    
    CGFloat lineSpace = (self.showHeight - totalHeight) / (containers.count - 1);
    
    CGFloat topMargin = self.top;
    CGFloat leftMargin = self.left;
    for (NVLayoutContainer * container in containers) {
        CGFloat downOffset = topMargin - container.top;
        CGFloat leftOffset = leftMargin - container.left;
        
        for (UIView * view in container.subviews) {
            view.top += downOffset;
            view.left += leftOffset;
        }
        container.origin = CGPointMake(leftMargin, topMargin);
        topMargin += container.height + lineSpace;
    }
    
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
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

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

@end
