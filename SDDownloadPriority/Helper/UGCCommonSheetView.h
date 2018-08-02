//
//  UGCCommonSheetView.h
//  UGCBase
//
//  Created by MengWang on 2017/11/10.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,UGCCommonSheetViewItemStyle)
{
    UGCCommonSheetViewItemStyleDefault,
    UGCCommonSheetViewItemStyleCancel
};

@interface UGCCommonSheetViewItem : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subTitle;
@property (nonatomic, copy)           NSString *ga_label;

+ (UGCCommonSheetViewItem *)actionWithTitle:(NSString *)title
                                      subTitle:(NSString *)subtitle
                                         style:(UGCCommonSheetViewItemStyle)style
                                       handler:(void(^)(UGCCommonSheetViewItem *))handler;

@end

@interface UGCCommonSheetView : UIView

- (void)addActionItem:(UGCCommonSheetViewItem *)item;
- (void)show;

@end
