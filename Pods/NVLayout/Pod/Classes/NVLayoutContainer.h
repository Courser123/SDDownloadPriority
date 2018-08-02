//
//  NVLinearLayoutContainer.h
//  Pods
//
//  Created by 纪鹏 on 2016/10/31.
//
//

//该类借鉴了UIStackView和Android线性布局的理念，为NVLayout提供了一个布局容器。
//适用于多个view在同一行进行排列，提供更加方便清晰的声明式布局方法。特地为NVLayout添加了对文本控件的支持，融入了文本baseline对齐的概念。

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NVLayoutHorizontalAlignment) {
    NVLayoutHorizontalAlignmentLeft = 0,
    NVLayoutHorizontalAlignmentRight,
    NVLayoutHorizontalAlignmentCenter
};

typedef NS_ENUM(NSUInteger, NVLayoutVerticalAlignment) {
    NVLayoutVerticalAlignmentBottom = 0,
    NVLayoutVerticalAlignmentTop,
    NVLayoutVerticalAlignmentCenter
};


@interface NVLayoutContainer : NSObject

/*
 * 初始化方法。将需要进行布局的view作为参数传入。类似于NSArray arrayWithObjects方法的可变参数传递方式，以nil作为参数结束的标志。
 */
+ (instancetype)containerViews:(UIView*)subview, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)containerViewArray:(NSArray<UIView *> *)subviewArray;

+ (UIView *)placeHolderView;

@property (nonatomic, readonly, copy) NSArray <UIView *> * subviews;

/*
 * view之间的间隔。默认为0
 */
@property (nonatomic, assign) CGFloat divideSpace;

/*
 * 水平方向的对齐方式. 默认是 NVLayoutHorizontalAlignmentLeft
 */
@property (nonatomic, assign) NVLayoutHorizontalAlignment horizontalAlignment;
/*
 * 垂直方向的对齐方式. 默认是 NVLayoutVerticalAlignmentBottom
 */
@property (nonatomic, assign) NVLayoutVerticalAlignment verticalAlignment;
/*
 * 默认值为Yes。baseLine是匠心布局中新增的一个重要的属性，大部分类型的view的baseline和bottom的值相同。UILabel中，baseline是指label中字符的底端，对齐baseline就是让container中所有view的baseline在同一水平线上。实际应用效果就是label中文字的底端与imageview的bottom对齐。
 */
@property (nonatomic, assign) BOOL baseLineAlignment;

/*
 * 根据container中的views确定container的大小，需在layout之前调用。调用后会相应地改变frame的size。
 */
- (void)sizeToFit;
/*
 * 进行布局。设置好container的属性，确定view的大小之后，调用layout开始对container中的views进行布局。该函数仅仅改变子view的位置，不改变大小，需事先设置好子view的大小。
 */
- (void)layout;


//以下属性为container提供类似view的操作
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat maxShowWidth;

- (void)preComputeSubviewsSize;

- (void)insertLastSubview:(UIView *)view;

- (void)autoLayout;

@end

