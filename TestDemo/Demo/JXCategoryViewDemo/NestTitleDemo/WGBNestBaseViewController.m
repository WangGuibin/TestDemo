//
// WGBNestBaseViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/4/14
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
    

#import "WGBNestBaseViewController.h"
#import "WGBNestSubViewController.h"

@interface WGBNestBaseViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *navBgView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray *VCsArray;

@end

@implementation WGBNestBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSlideSwitch];
    [self buildLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

    ///MARK:- 创建顶部滑动标签栏
- (void)setupSlideSwitch{
    NSArray *titles = @[@"动态",@"项目",@"活动"];
    for (NSInteger i = 0; i < titles.count ; i++) {
        WGBNestSubViewController *subVC = [[WGBNestSubViewController alloc] init];
        [self.VCsArray addObject: subVC];
    }
    
    self.categoryView.titles = titles;
    self.categoryView.defaultSelectedIndex = 0;
    self.listContainerView.defaultSelectedIndex = 0;
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    [self.listContainerView reloadData];
    [self.categoryView reloadData];
}

//MARK:- Layout
- (void)buildLayout{
    [self.navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
                // Fallback on earlier versions
            make.top.equalTo(self.view).offset(kStatusBarHeight);
        }
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navBgView).offset(-5);
        make.centerY.equalTo(self.navBgView);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addButton.mas_left).offset(-5);
        make.centerY.equalTo(self.navBgView);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBgView);
        make.right.equalTo(self.searchButton.mas_left).offset(-5);
        make.centerY.equalTo(self.navBgView);
        make.height.mas_equalTo(40);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBgView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    return (id<JXCategoryListContentViewDelegate>)self.VCsArray[index];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
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
    return self.VCsArray.count;
}

/// lazy load
- (NSMutableArray *)VCsArray {
    if (!_VCsArray) {
        _VCsArray = [[NSMutableArray alloc] init];
    }
    return _VCsArray;
}

- (UIView *)navBgView {
    if (!_navBgView) {
        _navBgView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_navBgView];
    }
    return _navBgView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , 40)];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titleColor = [UIColor blackColor];
        _categoryView.titleFont = KFontSize(20);
        _categoryView.titleSelectedColor = [UIColor orangeColor];
        _categoryView.titleSelectedFont = KFontSize(30);
        _categoryView.cellSpacing = 30.0f;
        _categoryView.contentEdgeInsetLeft = 15.0f;
        _categoryView.delegate = self;
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.titleLabelZoomEnabled = YES;          // 选中放大
        _categoryView.titleLabelStrokeWidthEnabled = YES;   // 选中加粗
        _categoryView.cellWidthZoomEnabled = YES; // 宽度缩放
        _categoryView.selectedAnimationEnabled = YES;
        [self.navBgView addSubview:_categoryView];
    }
    return _categoryView;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:[UIImage imageNamed:@"btn_wmc_yellow_search"] forState:UIControlStateNormal];
        [self.navBgView addSubview:_searchButton];
    }
    return _searchButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"btn_wmc_yellow_add"] forState:UIControlStateNormal];
        @weakify(self);
        [_addButton addTapActionWithBlock:^(UIGestureRecognizer * _Nullable gestureRecoginzer) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navBgView addSubview:_addButton];
    }
    return _addButton;
}


- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:(JXCategoryListContainerType_ScrollView) delegate:self];
        [self.view addSubview:_listContainerView];
    }
    return _listContainerView;
}


@end
