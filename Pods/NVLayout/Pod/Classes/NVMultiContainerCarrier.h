//
//  NVMultiContainerCarrier.h
//  NVLayout
//
//  Created by David on 2017/11/23.
//

#import <UIKit/UIKit.h>

@class NVLayoutContainer;

/*
 *
 * 布局后只改变除第一行之外的Laycontainer的subView的Top值
 *
 */
@interface NVMultiContainerCarrier : NSObject

+ (instancetype)carrierWithContainer:(NSArray<NVLayoutContainer *> *)containers;

@property (nonatomic, strong) NSArray <NVLayoutContainer *> * validSubContainers;

@property (nonatomic, assign) CGFloat showHeight;

- (void)sizeToFit;
- (void)layout;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGPoint origin;

@end
