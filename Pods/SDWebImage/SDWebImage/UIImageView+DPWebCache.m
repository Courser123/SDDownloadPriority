//
//  UIImageView+DPWebCache.m
//  SDWebImage
//
//  Created by welson on 2018/2/23.
//

#import "UIImageView+DPWebCache.h"

@implementation UIImageView (DPWebCache)

- (void)dp_setImageWithURL:(NSURL *)url {
    [self dp_setImageWithURL:url
                   completed:nil];
}

- (void)dp_setImageWithURL:(NSURL *)url
                 completed:(SDWebImageCompletionBlock)completedBlock {
    [self dp_setImageWithURL:url
                     options:SDWebImageUseDPDefaultPlaceholder
                    progress:nil
                   completed:completedBlock];
}

- (void)dp_setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url
            placeholderImage:nil
                     options:options | SDWebImageUseDPDefaultPlaceholder
                    progress:progressBlock
                   completed:completedBlock];
}

@end
