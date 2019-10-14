//
//  SelectImagesDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SelectImagesDemoViewController.h"
#import "WGBSelectPhotoView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "YBImageBrowser.h"

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
    pickerVC.maxImagesCount = 9;
    [self presentViewController:pickerVC animated:YES completion:^{
        
    }];
    
    [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (self.selectImageArray.count) {
            [self.selectImageArray removeAllObjects];
        }
        [self.selectImageArray addObjectsFromArray:assets];
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

- (WGBSelectPhotoView *)selectPhotoView {
    if (!_selectPhotoView) {
        _selectPhotoView = [[WGBSelectPhotoView alloc] initWithFrame:CGRectMake(0, 88, KWIDTH, 100)];
        _selectPhotoView.backgroundColor = [UIColor cyanColor];
        _selectPhotoView.delegate = self;
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
