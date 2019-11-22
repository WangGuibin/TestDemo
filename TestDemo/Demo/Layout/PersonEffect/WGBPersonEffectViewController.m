//
// WGBPersonEffectViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/22
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
    

#import "WGBPersonEffectViewController.h"
#import "WGBPersonEffectNavBar.h"

#define kHeaderHeight  (150 + kNavBarHeight)

@interface WGBPersonEffectViewController ()<WGBPersonEffectNavBarDelegate,
UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) WGBPersonEffectNavBar *navBar;
@property (nonatomic,strong) UIImageView *headerView;

@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation WGBPersonEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lastOffsetY = -kHeaderHeight;
    
    // 设置顶部额外滚动区域
    self.collectionView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    [self.collectionView reloadData];
    [self.view bringSubviewToFront: self.navBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

///MARK:- <DFHContentNumberNavBarDelegate>
- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)watchCarFriendCycleAction{
    [WGBAlertTool showCustomTipsAlertWithMessage:@"该功能尚未开放" fromSuperView:nil leftButtonTitle:@"确定" rightButtonTitle:@"" leftButtonBlock:^{
        
    } rightButtonBlock:^{
        
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *ranColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    cell.backgroundColor = ranColor;
    ViewRadius(cell, 5);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    // 获取偏移量差值
    CGFloat delta = offsetY - _lastOffsetY;
    CGFloat headH = kHeaderHeight - delta;
    if (offsetY < kHeaderHeight) {
        self.collectionView.bounces = NO;
    }else{
        self.collectionView.bounces = YES;
    }
    //卡点在导航栏的位置
    if (headH < kNavBarHeight) {
        headH = kNavBarHeight;
        self.navBar.bgImageView.hidden = NO;
//        self.navBar.backgroundColor = RGB(255, 87, 87);
    }else{
        self.navBar.bgImageView.hidden = YES;
//        // 计算透明度
//        CGFloat alpha = delta/(kHeaderHeight - kNavBarHeight);
//        self.navBar.backgroundColor = RGBA(255, 87, 87, alpha);
    }
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top).offset(-delta);
    }];

}


///MARK:- lazy load
- (WGBPersonEffectNavBar *)navBar{
    if (!_navBar) {
        _navBar = [[WGBPersonEffectNavBar alloc] initWithFrame:CGRectZero];
        _navBar.delegate = self;
        [self.view addSubview:_navBar];
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(0);
            make.height.mas_equalTo(kNavBarHeight);
        }];
    }
    return _navBar;
}

- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , kHeaderHeight)];
        _headerView.image = [UIImage imageNamed:@"payzone_content_detail_bg"];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.clipsToBounds = YES;
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.navBar.mas_top);
            make.height.mas_equalTo(kHeaderHeight);
        }];
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (KWIDTH - 15)/2.0;
        layout.itemSize = CGSizeMake(itemW, 100);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        adjustsScrollViewInsets_NO(_collectionView, self);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(0);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
    }
    return _collectionView;
}

@end
