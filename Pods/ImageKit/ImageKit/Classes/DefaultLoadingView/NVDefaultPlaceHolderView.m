//
//  UGCDefaultPlaceHolderView.m
//  Pods
//
//  Created by 薛琳 on 17/2/14.
//
//

#import "NVDefaultPlaceHolderView.h"
#import "R_ImageKit.h"

@interface NVDefaultPlaceHolderView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *smallImage;
@property (nonatomic, strong) UIImage *bigImage;
@property (nonatomic, strong) UIImage *bigWithTitleImage;

@end

@implementation NVDefaultPlaceHolderView

#pragma mark - life cycle

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        self.backgroundColor = [UIColor colorWithRed:(230.0/255.0) green:(230.0/255.0) blue:(230.0/255.0) alpha:1];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.image = [self defaultImage];
    [self.imageView sizeToFit];
    self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

#pragma mark - properties

- (UIImage *)defaultImage {
    if (self.frame.size.width > 300 && self.frame.size.height > 60) {
        return self.bigWithTitleImage;
    }else if (self.frame.size.width <= 300 && self.frame.size.width > 60 && self.frame.size.height > 60) {
        return self.bigImage;
    }else if ((self.frame.size.width <= 60 && self.frame.size.width > 40) || (self.frame.size.height <= 60 && self.frame.size.height > 40)) {
        return self.smallImage;
    }
    return nil;
}

- (UIImage *)smallImage {
    if (!_smallImage) {
        _smallImage = [self imageNamed:R_imagerelated_small_loading inBundleOfClass:[self class]];
    }
    return _smallImage;
}

- (UIImage *)bigImage {
    if (!_bigImage) {
        _bigImage = [self imageNamed:R_imagerelated_big_loading inBundleOfClass:[self class]];
    }
    return _bigImage;
}

- (UIImage *)bigWithTitleImage {
    if (!_bigWithTitleImage) {
        _bigWithTitleImage = [self imageNamed:R_imagerelated_big_title_loading inBundleOfClass:[self class]];
    }
    return _bigWithTitleImage;
}

- (UIImage *)imageNamed:(NSString *)name inBundleOfClass:(Class)cls {
    if (!name || !cls) return nil;
    NSBundle *bundle = [NSBundle bundleForClass:cls];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
