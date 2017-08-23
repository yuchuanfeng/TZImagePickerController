//
//  YZJMinePreviewPhotoViewController.h
//  TZImagePickerController
//
//  Created by 于传峰 on 2017/4/3.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZJMinePreviewPhotoViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *photos;                  ///< All photos  / 所有图片数组
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) NSInteger currentIndex;


@property (nonatomic, copy) void (^doneButtonClickBlockWithPreviewType)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);
@end
