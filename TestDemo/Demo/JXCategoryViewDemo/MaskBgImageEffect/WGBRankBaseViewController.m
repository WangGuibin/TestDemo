//
// WGBRankBaseViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/23
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
    

#import "WGBRankBaseViewController.h"
#import "WGBRankTopBgHeader.h"
#import "WGBRankSubViewController.h"

@interface WGBRankBaseViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>

@property (nonatomic,strong) WGBRankTopBgHeader *topHeader;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *VCsArray;

@end

@implementation WGBRankBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront: self.topHeader];
    [self setup];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topHeader.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

- (void)setup{
     [self.titlesArray addObjectsFromArray:@[@"付费榜",@"口碑榜",@"原创榜"]];
     for (NSInteger i = 0; i < self.titlesArray.count ; i++) {
         WGBRankSubViewController *VC = [[WGBRankSubViewController alloc] init];
         [self.VCsArray addObject: VC];
     }

     self.categoryView.titles = self.titlesArray;
     self.categoryView.defaultSelectedIndex = 0;
     self.listContainerView.defaultSelectedIndex = 0;
     self.categoryView.contentScrollView = self.listContainerView.scrollView;
     [self.categoryView reloadData];
     [self.listContainerView reloadData];
}

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    return (id<JXCategoryListContentViewDelegate>)self.VCsArray[index];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *ranColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.topHeader.backgroundColor = ranColor;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex: index];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titlesArray.count;
}


///MARK:- Lazy load
- (WGBRankTopBgHeader *)topHeader{
    if (!_topHeader) {
        _topHeader = [[WGBRankTopBgHeader alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , kNavBarHeight)];
        [self.view addSubview:_topHeader];
        [_topHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(kNavBarHeight+40);
        }];
    }
    return _topHeader;
}


- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , 35)];
        _categoryView.backgroundColor = [UIColor clearColor];
        _categoryView.titleColor = [UIColor whiteColor];
        _categoryView.titleSelectedColor = RGB(43, 32, 32);
        _categoryView.cellSpacing = 20;
        _categoryView.delegate = self;
        _categoryView.titleColorGradientEnabled = YES;
        JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"rank_list_header_mask"];
        indicatorImageView.indicatorImageViewSize = CGSizeMake(90, 35);
        _categoryView.indicators = @[indicatorImageView];
        [self.topHeader addSubview: _categoryView];
        [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topHeader.mas_bottom);
            make.left.equalTo(self.topHeader).offset(15);
            make.right.equalTo(self.topHeader).offset(-15);
            make.height.mas_equalTo(35);
        }];
    }
    return _categoryView;
}


- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:(JXCategoryListContainerType_ScrollView) delegate:self];
        [self.view addSubview:_listContainerView];
    }
    return _listContainerView;
}


- (NSMutableArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [[NSMutableArray alloc] init];
    }
    return _titlesArray;
}


- (NSMutableArray *)VCsArray {
    if (!_VCsArray) {
        _VCsArray = [[NSMutableArray alloc] init];
    }
    return _VCsArray;
}

@end
