/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIImageView+ExtraProperties.h"
#import "NVDefaultPlaceHolderView.h"

#ifdef SD_NVLogger
#import "NVCodeLogger.h"
#endif

#define kMaxImageSidePixel      1000

static char imageURLKey;
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;
static char TAG_HIDE_HUGEIMAGEHINT;
static char TAG_PLACEHOLDER_IMAGEVIEW;
static char TAG_PLACEHOLDER;
static char TAG_FADE_EFFECT;
static char removePlaceholderKey;

@implementation UIImageView (WebCache)

- (void)sd_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentImageLoad];
    
    //reset placeholderview
    [self.placeholderImageView removeFromSuperview];
    self.ifPlaceHolder = NO;
    
#ifdef DEBUG
    [self removeMaskLabel];
#endif
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    options |= SDWebImageRetryFailed;
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            [self sd_addPlaceholderImageViewWithFlag:(options & SDWebImageUseDPDefaultPlaceholder) placeholder:placeholder];
        });
    }
    
    if (url) {
        
        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }
        
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [wself removeActivityIndicator];
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
#ifdef DEBUG
                if (image && !self.sd_hideHugeImageHint) {
                    if (image.size.width >= kMaxImageSidePixel || image.size.height >= kMaxImageSidePixel) {
#ifdef SD_NVLogger
                        NVLog(@"Huge Photo Url:%@; Size:%@", url.absoluteString, NSStringFromCGSize(image.size));
#endif
                        UILabel *label = [self sd_hugeImageMaskLabel];
                        label.tag = 1024;
                        [self addSubview:label];
                    }
                }
#endif
                
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                {
                    self.needRemovePHView = YES;
                    completedBlock(image, error, cacheType, url);
                    if (self.ifPlaceHolder && self.needRemovePHView) [self sd_removePlaceholderImageView];
                    return;
                } else if (image) {
                    [wself sd_setImageWithFadeEffect:image
                                           cacheType:cacheType];
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        [wself sd_setImageWithFadeEffect:image
                                               cacheType:cacheType];
                        [wself setNeedsLayout];
                    }else {
                        [wself sd_removePlaceholderImageView];
                    }
                }
                if (error && self.dp_errorImage) self.image = self.dp_errorImage;
                if (!error && !image && self.dp_emptyImage) self.image = self.dp_emptyImage;
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        } caller:self];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
#ifdef SD_NVLogger
        NVLog(@"sd trying to load a nil url");
#endif
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            [self.placeholderImageView removeFromSuperview];
            if (self.dp_emptyImage) self.image = self.dp_emptyImage;
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_setImageWithFadeEffect:(UIImage *)image
                        cacheType:(SDImageCacheType)type {
    self.needRemovePHView = NO;
    if (self.sd_disableFadeEffect || type == SDImageCacheTypeMemory) {
        [self sd_removePlaceholderImageView];
        self.image = image;
        return;
    }
    
    if (self.ifPlaceHolder) {
        self.image = image;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.placeholderImageView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) [self sd_removePlaceholderImageView];
        }];
    }else {
        self.alpha = 0;
        self.image = image;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)sd_setImageWithFadeEffect:(UIImage *)image {
    [self sd_setImageWithFadeEffect:image
                          cacheType:SDImageCacheTypeNone];
}

- (UILabel *)sd_hugeImageMaskLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    label.textAlignment = NSTextAlignmentCenter;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.text = @"HUGE IMAGE";
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.4;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return label;
}

- (void)removeMaskLabel {
    for (UIView *subview in self.subviews) {
        if (subview.tag == 1024) {
            [subview removeFromSuperview];
            break;
        }
    }
}

- (void)sd_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self sd_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)sd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)sd_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self sd_cancelCurrentAnimationImagesLoad];
    __weak __typeof(self)wself = self;
    
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    
    for (NSURL *logoImageURL in arrayOfURLs) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];
                    
                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }
    
    [self sd_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)sd_cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}


#pragma mark -
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)setSd_hideHugeImageHint:(BOOL)hide {
    objc_setAssociatedObject(self, &TAG_HIDE_HUGEIMAGEHINT, [NSNumber numberWithBool:hide], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)sd_hideHugeImageHint {
    return [objc_getAssociatedObject(self, &TAG_HIDE_HUGEIMAGEHINT) boolValue];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }
    
    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });
    
}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

- (UIView *)placeholderImageView {
    return (UIView *)objc_getAssociatedObject(self, &TAG_PLACEHOLDER_IMAGEVIEW);
}

- (void)setPlaceholderImageView:(UIView *)placeholderImageView {
    objc_setAssociatedObject(self, &TAG_PLACEHOLDER_IMAGEVIEW, placeholderImageView, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)ifPlaceHolder {
    return [objc_getAssociatedObject(self, &TAG_PLACEHOLDER) boolValue];
}

- (void)setIfPlaceHolder:(BOOL)ifPlaceHolder {
    objc_setAssociatedObject(self, &TAG_PLACEHOLDER, @(ifPlaceHolder), OBJC_ASSOCIATION_RETAIN);
}

- (void)setNeedRemovePHView:(BOOL)flag {
    objc_setAssociatedObject(self, &removePlaceholderKey, @(flag), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)needRemovePHView {
    return [objc_getAssociatedObject(self, &removePlaceholderKey) boolValue];
}

- (BOOL)sd_disableFadeEffect {
    if (!objc_getAssociatedObject(self, &TAG_FADE_EFFECT)) {
        return YES;
    }
    return [objc_getAssociatedObject(self, &TAG_FADE_EFFECT) boolValue];
}

- (void)setSd_disableFadeEffect:(BOOL)sd_disableFadeEffect {
    objc_setAssociatedObject(self, &TAG_FADE_EFFECT, @(sd_disableFadeEffect), OBJC_ASSOCIATION_RETAIN);
}

- (void)sd_addPlaceholderImageViewWithFlag:(BOOL)fromdp placeholder:(UIImage *)image {
    self.image = image;
    self.placeholderImageView.alpha = 1;
    if (fromdp && !image && !self.dp_loadingImage) {
        self.ifPlaceHolder = YES;
        if ([self.placeholderImageView isKindOfClass:[NVDefaultPlaceHolderView class]]) return [self addSubview:self.placeholderImageView];
        NVDefaultPlaceHolderView *placeholderView = [NVDefaultPlaceHolderView new];
        placeholderView.frame = self.bounds;
        placeholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.placeholderImageView = placeholderView;
        [self addSubview:self.placeholderImageView];
        return;
    }
    
    if (image) return [self sd_addPlaceholderImageViewWithImage:image];
    if (self.dp_loadingImage) return [self sd_addPlaceholderImageViewWithImage:self.dp_loadingImage];
}

- (void)sd_addPlaceholderImageViewWithImage:(UIImage *)image {
    if (!image) return;
    self.ifPlaceHolder = YES;
    if ([self.placeholderImageView isKindOfClass:[UIImageView class]]) {
        self.placeholderImageView.frame = self.bounds;
        self.placeholderImageView.contentMode = self.contentMode;
        ((UIImageView *)self.placeholderImageView).image = image;
        [self addSubview:self.placeholderImageView];
        return;
    }
    
    UIImageView *placeholderImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    placeholderImageView.contentMode = self.contentMode;
    placeholderImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    placeholderImageView.image = image;
    self.placeholderImageView = placeholderImageView;
    [self addSubview:self.placeholderImageView];
    return;
}

- (void)sd_removePlaceholderImageView {
    if (!self.placeholderImageView) return;
    [self.placeholderImageView removeFromSuperview];
    self.placeholderImageView.alpha = 1;
}


@end


@implementation UIImageView (WebCacheDeprecated)

- (NSURL *)imageURL {
    return [self sd_imageURL];
}

- (void)setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentArrayLoad {
    [self sd_cancelCurrentAnimationImagesLoad];
}

- (void)cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self sd_setAnimationImagesWithURLs:arrayOfURLs];
}

@end

