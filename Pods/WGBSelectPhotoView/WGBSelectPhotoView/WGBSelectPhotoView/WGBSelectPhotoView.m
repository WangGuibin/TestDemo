//
//  WGBSelectPhotoView.m
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBSelectPhotoView.h"
#import "WGBSelectPhotoButton.h"

@interface WGBSelectPhotoView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *pictureBtnArr;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic,assign) NSInteger startIndex;//移动起始下标
@property (nonatomic,assign) NSInteger endIndex;//移动结束下标
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation WGBSelectPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefaultConfig];
    }
    return self;
}

- (void)initDefaultConfig{
    self.maxCount = 9;
    self.rowCount = 4;
    self.margin   = 15.0;
    self.spacing  = 10.0;
}

- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
}

- (void)setRowCount:(NSInteger)rowCount{
    _rowCount = rowCount;
}

- (void)setMargin:(CGFloat)margin{
    _margin = margin;
}

- (void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
}

///MARK:- 显式调用 显示加号按钮  调用时机是初始化完之后 或者 初始化完重新设置`maxCount`和`rowCount`之后 选择第一张图片之前
- (void)showAddButtonDisplay{
    //加号按钮先行
    [self addAddPictureButton];
}

///MARK:- 添加数据源数组
- (void)addPhotoesWithDataItems:(NSArray<WGBSelectPhotoDataItem *> *)items{
    if (self.pictureBtnArr.count == self.maxCount && ![self.pictureBtnArr.lastObject isAddButton]){
        return;
    }
    for (WGBSelectPhotoDataItem *item in items) {
        UIImage *img = item.coverImage;
        PHAsset *asset = item.assetObj;
        BOOL isVideo = NO;
        if (asset) {
            isVideo = item.assetObj.mediaType == PHAssetMediaTypeVideo;
        }
        [self addMediaCoverImageViewWithImage:img isVideoCoverImage: isVideo];
    }
}

//添加资源封面图片展示
- (void)addMediaCoverImageViewWithImage:(UIImage *)image
                 isVideoCoverImage:(BOOL)isVideo{
    if (self.pictureBtnArr.count == self.maxCount && ![self.pictureBtnArr.lastObject isAddButton]){
        return;
    }
    
    WGBSelectPhotoButton *btn = (WGBSelectPhotoButton *)self.pictureBtnArr.lastObject;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.isAddButton = NO;
    btn.isVideoButton = isVideo;
    if ([self picturesCount] == self.maxCount) {
        return;
    }
    [self addAddPictureButton];
}

//添加 添加图片的按钮
- (void)addAddPictureButton {
    CGRect frame = [self pictureButtonFrameWithIndex:self.pictureBtnArr.count];
    WGBSelectPhotoButton *addBtn = [[WGBSelectPhotoButton alloc] initWithFrame:frame];

    CGRect viewRect = self.frame;
    viewRect.size.height = CGRectGetMaxY(addBtn.frame) + self.margin;
    self.frame = viewRect;
    !self.updateHeightBlock? : self.updateHeightBlock(viewRect);

    __weak typeof(self) weakSelf = self;
    __weak typeof(addBtn) weakBtn = addBtn;
    addBtn.didClickButtonBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(wgb_photoViewDidClickedPhotoAtIndex:photoView:)]) {
            [weakSelf.delegate wgb_photoViewDidClickedPhotoAtIndex:[weakSelf.pictureBtnArr indexOfObject:weakBtn] photoView:self];
        }
    };
    
    addBtn.deletePhotoBlock = ^{
        [weakSelf deletePictureWithIndex:[weakSelf.pictureBtnArr indexOfObject:weakBtn]];
    };
    
    //手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(longPressGR:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.15;
    [addBtn addGestureRecognizer:longPress];
    
    [self.pictureBtnArr addObject:addBtn];
    [self addSubview:addBtn];
}

//删除图片
- (void)deletePictureWithIndex:(NSInteger)index {
    WGBSelectPhotoButton *btn = (WGBSelectPhotoButton *)self.pictureBtnArr[index];
    [btn removeFromSuperview];
    [self.pictureBtnArr removeObjectAtIndex:index];
    [self layoutViewFromIndex:index animation:NO];
    if ([self picturesCount] == self.maxCount-1) {
        [self addAddPictureButton];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wgb_photoViewDidDeletedPhotoAtIndex:photoView:)]) {
        [self.delegate wgb_photoViewDidDeletedPhotoAtIndex: index photoView:self];
    }
    
    //更新视图本身的frame 自适应高度
    CGRect frame = [self pictureButtonFrameWithIndex:self.pictureBtnArr.count - 1];
    CGRect viewRect = self.frame;
    viewRect.size.height = CGRectGetMaxY(frame) + self.margin;
    self.frame = viewRect;
    !self.updateHeightBlock? : self.updateHeightBlock(viewRect);
}

- (NSUInteger)picturesCount {
    if ([self.pictureBtnArr.lastObject isAddButton]) {
        return self.pictureBtnArr.count - 1;
    }else {
        return self.pictureBtnArr.count;
    }
}

- (NSUInteger)pictureButtonsCount {
    return self.pictureBtnArr.count;
}

- (void)layoutViewFromIndex:(NSInteger)index animation:(BOOL)animation {
    if (animation) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf layoutViewFromIndex:index];
        }];
    }else {
        [self layoutViewFromIndex:index];
    }
}

- (void)layoutButtonsExceptAtIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        for (NSInteger i = 0; i<weakSelf.pictureBtnArr.count; i++) {
            if (i == index) continue;
            [weakSelf layoutViewAtIndex:i];
        }
    }];
}

- (void)layoutViewFromIndex:(NSInteger)index {
    for (NSInteger i = index; i<self.pictureBtnArr.count; i++) {
        [self layoutViewAtIndex:i];
    }
}

- (void)layoutViewAtIndex:(NSInteger)index {
    WGBSelectPhotoButton *btn = (WGBSelectPhotoButton *)self.pictureBtnArr[index];
    CGRect frame = [self pictureButtonFrameWithIndex:index];
    btn.frame = frame;
}

//图片frame
- (CGRect)pictureButtonFrameWithIndex:(NSInteger)index {
    CGFloat sizeW = (self.frame.size.width - self.margin*2 - self.spacing*(self.rowCount-1))/self.rowCount;
    CGFloat sizeH = sizeW;
    
    CGFloat buttonX = (index%self.rowCount)*(self.spacing+sizeW) + self.margin;
    CGFloat buttonY = (index/self.rowCount)*(self.spacing+sizeH) + self.margin;
    
    return CGRectMake(buttonX, buttonY, sizeW, sizeH);
}

//移动手势
- (void)longPressGR:(UILongPressGestureRecognizer *)sender {
    WGBSelectPhotoButton *btn = (WGBSelectPhotoButton *)sender.view;
    if ([btn isAddButton]){
        return;
    }
    self.centerPoint = btn.center;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self longPressGestureRecognizerBeganWithLongPress:sender dragBtn:btn];
            break;
        case UIGestureRecognizerStateChanged:
            [self longPressGestureRecognizerChangedWithLongPress:sender dragBtn:btn];
            break;
        case UIGestureRecognizerStateEnded:
            [self longPressGestureRecognizerEnded];
            break;
        default:
            break;
    }
}

- (void)longPressGestureRecognizerBeganWithLongPress:(UILongPressGestureRecognizer *)sender dragBtn:(WGBSelectPhotoButton *)btn {
    self.originPoint = self.centerPoint;
    self.startPoint = [sender locationInView:self];
    self.selectedIndex = [self.pictureBtnArr indexOfObject:btn];
    self.startIndex = self.selectedIndex;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat margin = weakSelf.spacing/2;
        CGRect frame = btn.frame;
        btn.frame = CGRectMake(frame.origin.x-margin,
                               frame.origin.y-margin,
                               frame.size.width+weakSelf.spacing,
                               frame.size.height+weakSelf.spacing);
        btn.alpha = 0.7;
    }];
}

- (void)longPressGestureRecognizerChangedWithLongPress:(UILongPressGestureRecognizer *)sender dragBtn:(WGBSelectPhotoButton *)btn {
    CGPoint point = [sender locationInView:self];
    CGPoint center = self.originPoint;
    center.x += point.x - self.startPoint.x;
    center.y += point.y - self.startPoint.y;
    btn.center = center;
    
    CGFloat sizeW = (self.frame.size.width - self.margin*2 - self.spacing*(self.rowCount-1))/self.rowCount;
    CGFloat sizeH = sizeW;
    NSUInteger indexX = (center.x - self.margin)/(sizeW + self.spacing);
    NSUInteger indexY = (center.y - self.margin)/(sizeH + self.spacing);
    NSUInteger index  = indexX + indexY*self.rowCount;
    
    if (index >= self.pictureBtnArr.count-1) {
        if ([self.pictureBtnArr.lastObject isAddButton]) {
            index = self.pictureBtnArr.count - 2;
        }else {
            index = self.pictureBtnArr.count - 1;
        }
    }
    if (index != self.selectedIndex) {
        self.selectedIndex = index;
        self.endIndex = index;
        [self.pictureBtnArr removeObject:btn];
        [self.pictureBtnArr insertObject:btn atIndex:index];
        [self layoutButtonsExceptAtIndex:index];
    }
}

- (void)longPressGestureRecognizerEnded {
    [self layoutViewAtIndex:self.selectedIndex];
    WGBSelectPhotoButton *btn = self.pictureBtnArr[self.selectedIndex];
    btn.alpha = 1;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wgb_photoViewDidMovedPhotoWithStartIndex:endIndex:photoView:)]) {
        [self.delegate wgb_photoViewDidMovedPhotoWithStartIndex:self.startIndex endIndex:self.endIndex photoView:self];
    }
    self.startIndex = self.selectedIndex;
    self.endIndex = self.selectedIndex;
}

#pragma mark - getters & setters
- (NSMutableArray *)pictureBtnArr {
    if (!_pictureBtnArr) {
        _pictureBtnArr  = [[NSMutableArray alloc] init];
    }
    return _pictureBtnArr;
}

@end


@implementation WGBSelectPhotoDataItem

///MARK:- 获取相册选择的数据源
+ (NSArray<WGBSelectPhotoDataItem *> *)createDataItemsWithPHAssets:(NSArray<PHAsset*> *)mediaAssets
                                                           photoes:(NSArray<UIImage*>*)photoes{
    if (!photoes.count) {
        return nil;
    }
    NSMutableArray *dataSource = [NSMutableArray array];
    [photoes enumerateObjectsUsingBlock:^(UIImage * _Nonnull img, NSUInteger index, BOOL * _Nonnull stop) {
        WGBSelectPhotoDataItem *item = [WGBSelectPhotoDataItem new];
        item.assetObj = mediaAssets[index];
        item.coverImage = img;
        [dataSource addObject: item];
    }];
    return dataSource;
}



@end

