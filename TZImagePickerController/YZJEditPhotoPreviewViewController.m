//
//  YZJEditPhotoPreviewViewController.m
//  TZImagePickerController
//
//  Created by 于传峰 on 2017/4/6.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import "YZJEditPhotoPreviewViewController.h"
#import "UIView+Layout.h"
#import "TZImageManager.h"
#import "TZImageCropManager.h"

@interface YZJEditPhotoPreviewViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, assign) CGRect cropRect;


@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;
@end

@implementation YZJEditPhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _cropRect = CGRectMake(10, 50, 100, 300);
    [self setupSubviews];
    [self resizeSubviews];
}


- (void)setupSubviews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.view.tz_width, self.view.tz_height);
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 4;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    [self.view addSubview:_scrollView];
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.image = self.image;
    [_imageContainerView addSubview:_imageView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self.view addGestureRecognizer:tap2];
    
    _cropBgView = [UIView new];
    _cropBgView.userInteractionEnabled = NO;
    _cropBgView.backgroundColor = [UIColor clearColor];
    _cropBgView.frame = self.view.bounds;
    [self.view addSubview:_cropBgView];
    [TZImageCropManager overlayClippingWithView:_cropBgView cropRect:_cropRect containerView:self.view needCircleCrop:NO];
    
    _cropView = [UIView new];
    _cropView.userInteractionEnabled = NO;
    _cropView.backgroundColor = [UIColor clearColor];
    _cropView.frame = _cropRect;
    _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
    _cropView.layer.borderWidth = 1.0;
    [self.view addSubview:_cropView];
    
    
    [self setupFootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
}

- (void)setupFootView {
    UIView* footView = [[UIView alloc] init];
    [self.view addSubview:footView];
    footView.backgroundColor = [UIColor redColor];
    footView.frame = CGRectMake(0, self.view.tz_height - 120, self.view.tz_width, 120);
    
    UIView* toolBarView = [[UIView alloc] init];
    [footView addSubview:toolBarView];
    toolBarView.backgroundColor = [UIColor whiteColor];
    toolBarView.frame = CGRectMake(0, footView.tz_height - 50, footView.tz_width, 50);
    
    
    UIButton* resetBtn = [[UIButton alloc] init];
    [toolBarView addSubview:resetBtn];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn sizeToFit];
    [resetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [resetBtn addTarget:self action:@selector(resetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    resetBtn.tz_centerX = toolBarView.tz_width * 0.5;
    resetBtn.tz_height = toolBarView.tz_height;
    
    UIButton* cancelBtn = [[UIButton alloc] init];
    [toolBarView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn sizeToFit];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tz_right = resetBtn.tz_left - 84;
    cancelBtn.tz_height = toolBarView.tz_height;
    
    UIButton* submitBtn = [[UIButton alloc] init];
    [toolBarView addSubview:submitBtn];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn sizeToFit];
    [submitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tz_left = resetBtn.tz_right + 84;
    submitBtn.tz_height = toolBarView.tz_height;
}

#pragma mark - UITapGestureRecognizer Event

- (void)cancelBtnClicked:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)resetBtnClicked:(UIButton *)button {
    
}
- (void)submitBtnClicked:(UIButton *)button {
    UIImage *cropedImage = [TZImageCropManager cropImageView:self.imageView toRect:_cropRect zoomScale:_scrollView.zoomScale containerView:self.view];
    if (self.submitButtonClickBlockCropMode)
    {
        self.submitButtonClickBlockCropMode(cropedImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.view.frame.size.width / newZoomScale;
        CGFloat ysize = self.view.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {

    
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self refreshScrollViewContentSize];
}

#pragma mark - Private

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.tz_origin = CGPointZero;
    _imageContainerView.tz_width = self.scrollView.tz_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.view.tz_height / self.scrollView.tz_width) {
        _imageContainerView.tz_height = floor(image.size.height / (image.size.width / self.scrollView.tz_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.tz_width;
        if (height < 1 || isnan(height)) height = self.view.tz_height;
        height = floor(height);
        _imageContainerView.tz_height = height;
        _imageContainerView.tz_centerY = self.view.tz_height / 2;
    }
    if (_imageContainerView.tz_height > self.view.tz_height && _imageContainerView.tz_height - self.view.tz_height <= 1) {
        _imageContainerView.tz_height = self.view.tz_height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.tz_height, self.view.tz_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.tz_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.view.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.tz_height <= self.view.tz_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    
    [self refreshScrollViewContentSize];
}


- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.tz_width > _scrollView.contentSize.width) ? ((_scrollView.tz_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.tz_height > _scrollView.contentSize.height) ? ((_scrollView.tz_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}
- (void)refreshScrollViewContentSize {
    // 1.7.2 如果允许裁剪,需要让图片的任意部分都能在裁剪框内，于是对_scrollView做了如下处理：
    // 1.让contentSize增大(裁剪框右下角的图片部分)
    CGFloat contentWidthAdd = self.scrollView.tz_width - CGRectGetMaxX(_cropRect);
    CGFloat contentHeightAdd = (MIN(_imageContainerView.tz_height, self.view.tz_height) - self.cropRect.size.height) / 2;
    CGFloat newSizeW = self.scrollView.contentSize.width + contentWidthAdd;
    CGFloat newSizeH = MAX(self.scrollView.contentSize.height, self.view.tz_height) + contentHeightAdd;
    _scrollView.contentSize = CGSizeMake(newSizeW, newSizeH);
    _scrollView.alwaysBounceVertical = YES;
    // 2.让scrollView新增滑动区域（裁剪框左上角的图片部分）
    if (contentHeightAdd > 0) {
        _scrollView.contentInset = UIEdgeInsetsMake(contentHeightAdd, _cropRect.origin.x, 0, 0);
    } else {
        _scrollView.contentInset = UIEdgeInsetsZero;
    }
}

@end
