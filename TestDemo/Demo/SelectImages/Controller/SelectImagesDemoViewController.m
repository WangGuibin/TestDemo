//
//  SelectImagesDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
// https://github.com/WangGuibin/WGBSelectPhotoView

#import "SelectImagesDemoViewController.h"
#import "WGBSelectPhotoView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "YBImageBrowser.h"

#define kMaxSelectImagesCount 9

@interface SelectImagesDemoViewController ()<WGBSelectPhotoViewDelegate>

@property (nonatomic, strong) WGBSelectPhotoView *selectPhotoView;
@property (nonatomic, strong) NSMutableArray *selectImageArray;

@end

@implementation SelectImagesDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.selectPhotoView];
}

- (void)selectPhoto{
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] init];
    pickerVC.maxImagesCount = kMaxSelectImagesCount;
    [self presentViewController:pickerVC animated:YES completion:^{
        
    }];
    
    [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (self.selectImageArray.count + assets.count > kMaxSelectImagesCount) {
            NSString *message = [NSString stringWithFormat:@"最多只能选择%ld张照片",(long)kMaxSelectImagesCount];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction: action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        ///MARK：- 优雅的方式 只获取`kMaxSelectImagesCount`张
        if (self.selectImageArray.count) {
            NSInteger detaCount = kMaxSelectImagesCount - self.selectImageArray.count;
            detaCount = MIN(detaCount, assets.count);
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,detaCount)];
            NSArray *tempAssets = [assets objectsAtIndexes:indexes];
            [self.selectImageArray addObjectsFromArray:tempAssets];
        }else{
            [self.selectImageArray addObjectsFromArray:assets];
        }
        [self.selectPhotoView addPhotoesWithImages: photos];
    }];
}

#pragma mark - <WGBSelectPhotoViewDelegate>
- (void)wgb_photoViewDidClickedPhotoAtIndex:(NSInteger)index{
    if (index == [self.selectPhotoView picturesCount]) {
        [self selectPhoto];
    }else {
//        NSLog(@"%ld",index);
        NSMutableArray *localImageDataArr = [NSMutableArray array];
        for (PHAsset *imageAsset in self.selectImageArray) {
            YBIBImageData *imageData = [YBIBImageData new];
            imageData.imagePHAsset = imageAsset;
            [localImageDataArr addObject:imageData];
        }
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.defaultToolViewHandler.topView.operationButton.hidden = YES;
        browser.dataSourceArray = localImageDataArr;
        browser.currentPage = index;
        [browser show];
    }
}

//删除图片事件回调
- (void)wgb_photoViewDidDeletedPhotoAtIndex:(NSInteger)index{
    if (self.selectImageArray.count) {
        [self.selectImageArray removeObjectAtIndex: index];
    }
}

//https://github.com/WangGuibin/WGBSelectPhotoView
- (WGBSelectPhotoView *)selectPhotoView {
    if (!_selectPhotoView) {
        _selectPhotoView = [[WGBSelectPhotoView alloc] initWithFrame:CGRectMake(0, 88, KWIDTH, 100)];
        _selectPhotoView.backgroundColor = [UIColor cyanColor];
        _selectPhotoView.delegate = self;
        [_selectPhotoView showAddButtonDisplay];
    }
    return _selectPhotoView;
}


- (NSMutableArray *)selectImageArray {
    if (!_selectImageArray) {
        _selectImageArray = [[NSMutableArray alloc] init];
    }
    return _selectImageArray;
}

@end
