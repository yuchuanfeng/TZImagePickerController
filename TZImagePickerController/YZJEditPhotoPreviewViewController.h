//
//  YZJEditPhotoPreviewViewController.h
//  TZImagePickerController
//
//  Created by 于传峰 on 2017/4/6.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZJEditPhotoPreviewViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void (^submitButtonClickBlockCropMode)(UIImage *cropedImage);
@end
