//
// WGBRecognitionPictureColorViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/10
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "WGBRecognitionPictureColorViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "iOSPalette.h"
#import "DemoShowColorViewCell.h"

@interface WGBRecognitionPictureColorViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *colorDisplayView;
@property (nonatomic, strong) NSDictionary *allModeColorDic;

@end

@implementation WGBRecognitionPictureColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 150 , 30);
    [button setTitle:@"选择图片" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(selectImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    
}

- (void)selectImageAction{
     
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] init];
    pickerVC.allowPickingVideo = NO;
    pickerVC.allowPickingMultipleVideo = NO;//多选
    pickerVC.maxImagesCount = 1;
    [self presentViewController:pickerVC animated:YES completion:^{
        
    }];
    [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *image = photos.firstObject;
        [image getPaletteImageColorWithMode:ALL_MODE_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic,NSError *error) {
            if (!recommendColor){
                return;
            }
            self.allModeColorDic = allModeColorDic;
            [self.colorDisplayView reloadData];
        }];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allModeColorDic.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DemoShowColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DemoShowColorViewCell class]) forIndexPath:indexPath];
    if (!cell){
        cell = [[DemoShowColorViewCell alloc] init];
    }
    PaletteColorModel *colorModel;
    NSString *modeKey;
    switch (indexPath.row) {
        case 0:
            colorModel = [self.allModeColorDic objectForKey:@"vibrant"];
            modeKey = @"vibrant";
            break;
        case 1:
            colorModel = [self.allModeColorDic objectForKey:@"muted"];
            modeKey = @"muted";
            break;
        case 2:
            colorModel = [self.allModeColorDic objectForKey:@"light_vibrant"];
            modeKey = @"light_vibrant";
            break;
        case 3:
            colorModel = [self.allModeColorDic objectForKey:@"light_muted"];
            modeKey = @"light_muted";
            break;
        case 4:
            colorModel = [self.allModeColorDic objectForKey:@"dark_vibrant"];
            modeKey = @"dark_vibrant";
            break;
        case 5:
            colorModel = [self.allModeColorDic objectForKey:@"dark_muted"];
            modeKey = @"dark_muted";
            break;
            
        default:
            break;
    }
    [cell configureData:colorModel andKey:modeKey];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
}

- (UICollectionView *)colorDisplayView {
    if (!_colorDisplayView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.width / 2 , 100);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _colorDisplayView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _colorDisplayView.dataSource = self;
        _colorDisplayView.delegate = self;
        [_colorDisplayView registerClass:[DemoShowColorViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DemoShowColorViewCell class])];
        [self.view addSubview:_colorDisplayView];
        _colorDisplayView.backgroundColor = [UIColor whiteColor];
        [_colorDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(180);
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
    }
    return _colorDisplayView;
}

@end
