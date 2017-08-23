//
//  YZJMinePreviewPhotoViewController.m
//  TZImagePickerController
//
//  Created by 于传峰 on 2017/4/3.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import "YZJMinePreviewPhotoViewController.h"
#import "TZPhotoPreviewCell.h"
#import "TZAssetModel.h"
#import "UIView+Layout.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZImageCropManager.h"

@interface YZJMinePreviewPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_deleteButton;
    UILabel* _indexLabel;
}

@property (nonatomic, strong) NSMutableArray *models;                  ///< All photo models / 所有图片模型数组

@property (nonatomic, assign) BOOL isHideNaviBar;

@property (nonatomic, assign) double progress;

@end

@implementation YZJMinePreviewPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TZImageManager manager].shouldFixOrientation = YES;
    [self configCollectionView];
    [self configCustomNaviBar];
    self.view.clipsToBounds = YES;
}

- (NSMutableArray *)models {
    if (!_models)
    {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
}

- (void)setSelectedAssets:(NSMutableArray *)selectedAssets {
    _selectedAssets = selectedAssets;
    [self.models removeAllObjects];
    for (id asset in selectedAssets) {
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhoto];
        model.isSelected = YES;
        [self.models addObject:model];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.tz_width + 20) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = NO;
    [TZImageManager manager].shouldFixOrientation = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configCustomNaviBar {
//    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.tz_width, 64)];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [_backButton setImage:[UIImage imageNamedFromMyBundle:@"navi_back.png"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    _deleteButton.frame = CGRectMake(self.view.tz_width - 54, 10, 42, 42);
    [_deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.center = _naviBar.center;
    _indexLabel.font = [UIFont systemFontOfSize:16];
    _indexLabel.textColor = [UIColor whiteColor];
    
    
    [_naviBar addSubview:_deleteButton];
    [_naviBar addSubview:_backButton];
    [_naviBar addSubview:_indexLabel];
    [self.view addSubview:_naviBar];
}


- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.tz_width + 20, self.view.tz_height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.tz_width + 20, self.view.tz_height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.tz_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZPhotoPreviewCell class] forCellWithReuseIdentifier:@"YZJPhotoPreviewCell"];
}


#pragma mark - Click Event

- (void)deleteImage:(UIButton *)selectButton {

    [_selectedAssets removeObjectAtIndex:_currentIndex];
    [self.photos removeObjectAtIndex:_currentIndex];
    [_models removeObjectAtIndex:_currentIndex];
    if (_models.count == 0)
    {
        [self backButtonClick];
        return;
    }
    [_collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_currentIndex inSection:0]]];
    
    if (_currentIndex > 0 && _currentIndex == _models.count)
    {
        _currentIndex --;
    }
    [self refreshNaviBarAndBottomBarState];
    

}

- (void)backButtonClick {
    if (self.doneButtonClickBlockWithPreviewType) {
        self.doneButtonClickBlockWithPreviewType(self.photos,_selectedAssets, NO);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.tz_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.tz_width + 20);
    
    if (currentIndex < _models.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YZJPhotoPreviewCell" forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    cell.allowCrop = NO;
    __weak typeof(self) weakSelf = self;
    if (!cell.singleTapGestureBlock) {
        __weak typeof(_naviBar) weakNaviBar = _naviBar;
        cell.singleTapGestureBlock = ^(){
            // show or hide naviBar / 显示或隐藏导航栏
            weakSelf.isHideNaviBar = !weakSelf.isHideNaviBar;
            weakNaviBar.hidden = weakSelf.isHideNaviBar;
        };
    }
    [cell setImageProgressUpdateBlock:^(double progress) {
        weakSelf.progress = progress;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

#pragma mark - Private Method

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)refreshNaviBarAndBottomBarState {
    if (_models.count == 0)
    {
       
    }else{
        _indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", _currentIndex + 1, _models.count];
    }
}

@end
