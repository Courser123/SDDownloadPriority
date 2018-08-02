//
//  UGCCommonSheetView.m
//  UGCBase
//
//  Created by MengWang on 2017/11/10.
//

#import "UGCCommonSheetView.h"
#import "UIView+Layout.h"
#import "UGCTouchMaskView.h"

@interface UGCCommonSheetViewItem()
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *subTitle;
@property (nonatomic, assign) UGCCommonSheetViewItemStyle style;
@property (nonatomic, copy) void (^completeHandler)(UGCCommonSheetViewItem *item);
@end

@implementation UGCCommonSheetViewItem

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (UGCCommonSheetViewItem *)actionWithTitle:(NSString *)title
                                      subTitle:(NSString *)subtitle
                                         style:(UGCCommonSheetViewItemStyle)style
                                       handler:(void (^)(UGCCommonSheetViewItem *))handler {
    UGCCommonSheetViewItem *item = [UGCCommonSheetViewItem new];
    item.title = title;
    item.subTitle = subtitle;
    item.completeHandler = handler;
    item.style = style;
    return item;
}

@end

@interface UGCSheetView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, assign) BOOL titleLabelSlim;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong)UGCCommonSheetViewItem *relativeItem;
@property (nonatomic, assign) BOOL highLighted;

@end

@implementation UGCSheetView

- (instancetype)init {
    if (self = [super init]) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor colorWithRed:(51.0/255) green:(51.0/255) blue:(51.0/255) alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.textColor = [UIColor colorWithRed:1 green:(102.0/255) blue:(51.0/255) alpha:1];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitleLabel];
        
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithRed:(225.0/255) green:(225.0/255) blue:(225.0/255) alpha:1];
        [self addSubview:_bottomLine];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setHighLighted:(BOOL)highLighted {
    _highLighted = highLighted;
    self.backgroundColor = highLighted?[UIColor colorWithRed:(248.0/255) green:(248.0/255) blue:(248.0/255) alpha:1]:[UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    if (self.titleLabel.width > self.width) self.titleLabel.width = self.width;
    [self.subTitleLabel sizeToFit];
    if (self.subTitleLabel.width > self.width) self.subTitleLabel.width = self.width;
    
    if (!self.subTitleLabel.height) {
        self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
    }else {
        CGFloat padding = 2;
        CGFloat top = (self.height - padding - self.titleLabel.height - self.subTitleLabel.height)/2;
        self.titleLabel.top = top;
        top = self.titleLabel.bottom;
        self.titleLabel.centerX = self.width/2;
        self.subTitleLabel.top = top + padding;
        self.subTitleLabel.centerX = self.width/2;
    }
    
    self.bottomLine.height = 0.5;
    self.bottomLine.width = self.width;
    self.bottomLine.bottom = self.height;
}

- (void)setRelativeItem:(UGCCommonSheetViewItem *)relativeItem {
    _relativeItem = relativeItem;
    self.titleLabel.text = relativeItem.title;
    self.subTitleLabel.text = relativeItem.subTitle;
    self.titleLabelSlim = relativeItem.style == UGCCommonSheetViewItemStyleCancel;
    [self setNeedsLayout];
}

- (void)setTitleLabelSlim:(BOOL)titleLabelSlim {
    _titleLabelSlim = titleLabelSlim;
    self.titleLabel.font = titleLabelSlim?[UIFont systemFontOfSize:17]:[UIFont boldSystemFontOfSize:17];
}

@end

@interface UGCCommonSheetView()

@property (nonatomic, strong) NSMutableArray <UGCCommonSheetViewItem *> *itemList;
@property (nonatomic, strong) NSMutableArray<UGCSheetView *> *viewList;
@property (nonatomic, strong) UGCCommonSheetViewItem *cancelItem;
@property (nonatomic, strong) UGCSheetView *cancelView;
@property (nonatomic, assign) BOOL needRebuildUI;
@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UGCTouchMaskView *maskView;

@end

@implementation UGCCommonSheetView

- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        _itemList = [NSMutableArray new];
        _viewList = [NSMutableArray new];
        _bgView = [UIView new];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _bgView.alpha = 0;
        _bgView.frame = [UIScreen mainScreen].bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_bgView addGestureRecognizer:tap];
        self.backgroundColor = [UIColor colorWithRed:(240.0/255) green:(240.0/255) blue:(240.0/255) alpha:1];
        
        _maskView = [UGCTouchMaskView new];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.frame = [UIScreen mainScreen].bounds;
        
        __weak typeof(UGCTouchMaskView) *weakMaskView = _maskView;
        __weak typeof(UGCCommonSheetView) *weakSelf = self;
        _maskView.stateDidChanged = ^(NSSet<UITouch *> *touches, UIEvent *event, UGCTouchMaskState state) {
//            NSLog(@"%@", @(state));
            UITouch *touch = [touches anyObject];
            CGPoint touchPoint = [touch locationInView:weakMaskView];
            CGPoint newP = [weakMaskView convertPoint:touchPoint toView:weakSelf];
            
            for (UGCSheetView *view in weakSelf.viewList) view.highLighted = NO;
            weakSelf.cancelView.highLighted = NO;
            
            UGCSheetView *sheetView = nil;
            if ([weakSelf pointInside:newP withEvent:event]) sheetView = [weakSelf findRespondSheetViewWithPoint:newP];
            
            switch (state) {
                case UGCTouchMaskStateBegin:
                {
                    
                }
                    break;
                case UGCTouchMaskStateMove:
                {
                    
                }
                    break;
                case UGCTouchMaskStateEnd:
                {
//                    NSLog(@"end!");
                    if (!sheetView) return [weakSelf close];
                    [weakSelf handleTapWithUGCSheetView:sheetView];
                }
                    break;
                case UGCTouchMaskStateCancel:
                {
//                    NSLog(@"cancelled!");
                    sheetView.highLighted = NO;
                }
                    break;
                default:
                    break;
            }
        };
    }
    return self;
}

- (UGCSheetView *)findRespondSheetViewWithPoint:(CGPoint)touchPoint {
    UGCSheetView *sheetView = nil;
    for (UGCSheetView *view in self.viewList) {
        if (CGRectContainsPoint(view.frame, touchPoint)) {
            sheetView = view;
            sheetView.highLighted = YES;
            break;
        }
    }
    if (!sheetView && CGRectContainsPoint(self.cancelView.frame, touchPoint)) {
        sheetView = self.cancelView;
        sheetView.highLighted = YES;
    }
    return sheetView;
}

- (void)addActionItem:(UGCCommonSheetViewItem *)item {
    if (item.style == UGCCommonSheetViewItemStyleCancel) {
        self.cancelItem = item;
    }else {
        [self.itemList addObject:item];
    }
    self.needRebuildUI = YES;
}

- (void)show {
    if (self.isAnimating) return;
    self.isAnimating = YES;
    if (self.needRebuildUI) {
        self.needRebuildUI = YES;
        [self buildUI];
        [self sizeToFit];
    }
    [self startAnimationWithCompleteHandler:^{
        self.isAnimating = NO;
    }];
}

- (void)startAnimationWithCompleteHandler:(void(^)())handler {
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    self.top = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bgView.alpha = 1.0;
        self.bottom = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        if (handler) handler();
    }];
}

- (void)endAnimationWithCompleteHandler:(void(^)())handler {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bgView.alpha = 0;
        self.top = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
        if (handler) handler();
    }];
}

- (void)buildUI {
    [self removeViews];
    for (int i = 0; i < self.itemList.count; i ++) {
        UGCSheetView *sheetview = [self viewAtIndex:i];
        sheetview.relativeItem = self.itemList[i];
        [self addSubview:sheetview];
    }
    if (self.cancelItem) {
        if (!self.cancelView) self.cancelView = [self createNewSheetView];
        self.cancelView.relativeItem = self.cancelItem;
        [self addSubview:self.cancelView];
    }
    [self setNeedsLayout];
}

- (void)removeViews {
    for (UGCSheetView *view in self.viewList) [view removeFromSuperview];
    [self.cancelView removeFromSuperview];
}

- (UGCSheetView *)viewAtIndex:(NSInteger)idx {
    if (idx < self.viewList.count) return self.viewList[idx];
    UGCSheetView *sheetView = [self createNewSheetView];
    [self.viewList addObject:sheetView];
    return sheetView;
}

- (UGCSheetView *)createNewSheetView {
    UGCSheetView *sheetView = [UGCSheetView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [sheetView addGestureRecognizer:tap];
    return sheetView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat top = 0;
    for (int i = 0; i < self.itemList.count; i ++) {
        UGCSheetView *view = self.viewList[i];
        view.height = 55;
        view.width = self.width;
        view.top = top;
        top = view.bottom;
        view.bottomLine.hidden = (i == self.itemList.count - 1);
    }
    
    self.cancelView.height = 55;
    self.cancelView.width = self.width;
    self.cancelView.bottom = self.height;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (self.isAnimating) return;
    UGCSheetView *view = (UGCSheetView *)gesture.view;
    [self endAnimationWithCompleteHandler:^{
        if (view.relativeItem.completeHandler) view.relativeItem.completeHandler(view.relativeItem);
    }];
}

- (void)handleTapWithUGCSheetView:(UGCSheetView *)sheetView {
    if (!sheetView) return;
    if (self.isAnimating) return;
    [self endAnimationWithCompleteHandler:^{
        if (sheetView.relativeItem.completeHandler) sheetView.relativeItem.completeHandler(sheetView.relativeItem);
    }];
}

- (void)close {
    [self endAnimationWithCompleteHandler:nil];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, self.itemList.count * 55 + (self.cancelItem?65:0));
}

@end

