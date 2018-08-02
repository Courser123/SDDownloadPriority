//
//  ImageViewBaseWaterFallCell.h
//  ImageViewBase_Example
//
//  Created by welson on 2018/3/12.
//  Copyright © 2018年 welson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewBaseWaterFallCell : UICollectionViewCell

@property (nonatomic, strong) NSURL *picURL;

+ (NSString *)cellIdentifier;

@end
