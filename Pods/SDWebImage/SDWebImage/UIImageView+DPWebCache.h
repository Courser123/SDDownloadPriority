//
//  UIImageView+DPWebCache.h
//  SDWebImage
//
//  Created by welson on 2018/2/23.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ExtraProperties.h"
#import "UIImageView+WebCache.h"

@interface UIImageView (DPWebCache)

- (void)dp_setImageWithURL:(NSURL *)url;
- (void)dp_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;
- (void)dp_setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

@end
