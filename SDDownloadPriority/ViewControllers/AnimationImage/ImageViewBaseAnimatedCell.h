//
//  ImageViewBaseAnimatedCell.h
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/5.
//  Copyright © 2018年 welson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewBaseAnimatedCell : UITableViewCell

//@property (nonatomic, strong) NSURL *picURL;
@property (nonatomic, assign) BOOL usePicassoImageView;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSString *identifier;

+ (NSString *)cellIdentifier;
+ (CGFloat)suggestHeight;

@end
