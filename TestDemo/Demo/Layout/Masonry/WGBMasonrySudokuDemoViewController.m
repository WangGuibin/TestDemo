//
// WGBMasonrySudokuDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/16
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
    

#import "WGBMasonrySudokuDemoViewController.h"

@interface WGBMasonrySudokuDemoViewController ()

@end

@implementation WGBMasonrySudokuDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
    }];
    
    for (NSInteger i = 0; i < 18 ; i++) {
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectZero];
        demoView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
        [bgView addSubview:demoView];
    }
    
    /**
    *  九宫格布局 固定ItemSize 可变ItemSpacing
    *
    *  @param fixedItemWidth  固定宽度
    *  @param fixedItemHeight 固定高度
    *  @param warpCount       折行点
    *  @param topSpacing      顶间距
    *  @param bottomSpacing   底间距
    *  @param leadSpacing     左间距
    *  @param tailSpacing     右间距
    */
    ///这种固定的写法 得提前计算好父视图的高度 不然item的上下间距调整不了
    /// 它这个设置的是父视图的上下左右边距
    ///
//    [bgView.subviews mas_distributeSudokuViewsWithFixedItemWidth:70 fixedItemHeight:70 warpCount:5 topSpacing:150 bottomSpacing:150 leadSpacing:10 tailSpacing:10];
    
////////////////////////////////////////////////////////////////////////
    /**
    *  九宫格布局 可变ItemSize 固定ItemSpacing
    *
    *  @param fixedLineSpacing      行间距
    *  @param fixedInteritemSpacing 列间距
    *  @param warpCount             折行点
    *  @param topSpacing            顶间距
    *  @param bottomSpacing         底间距
    *  @param leadSpacing           左间距
    *  @param tailSpacing           右间距
    */
    // 这种有点类似挤压item的大小了  父视图的大小还是得根据item数量和布局先确定好
    // 比上一种要好一些的是item的上下和左右间距可设置了
//    [bgView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:10 fixedInteritemSpacing:10 warpCount:5 topSpacing:150 bottomSpacing:200 leadSpacing:10 tailSpacing:10];
    
////////////////////////////////////////////////////////////////////////

    /**
    *  九宫格布局 固定ItemSize 固定ItemSpacing
    *  可由九宫格的内容控制SuperView的大小
    *  如果warpCount大于[self count]，该方法将会用空白的View填充到superview中
    *
    *  Sudoku Layout, has fixed item size, and fix item space
    *  If warp count greater than self.count, It's fill empty view to superview
    *
    *  @param fixedItemWidth        固定宽度，如果设置成0，则表示自适应，If set it to zero, indicates the adaptive.
    *  @param fixedItemHeight       固定高度，如果设置成0，则表示自适应，If set it to zero, indicates the adaptive.
    *  @param fixedLineSpacing      行间距
    *  @param fixedInteritemSpacing 列间距
    *  @param warpCount             折行点
    *  @param topSpacing            顶间距
    *  @param bottomSpacing         底间距
    *  @param leadSpacing           左间距
    *  @param tailSpacing           右间距
    *
    *  @return 一般情况下会返回[self copy], 如果warpCount大于[self count]，则会返回一个被空白view填充过的数组，可以让你循环调用removeFromSuperview或者干一些其他的事情;
    *  @return Normal will return [self copy], If warpCount bigger than [self count] , It will return a empty views filled array, you could enumerate [subview removeFromSuperview] or do other things;
    */

    [bgView.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0 fixedLineSpacing:10 fixedInteritemSpacing:10 warpCount:5 topSpacing:10 bottomSpacing:300 leadSpacing:10 tailSpacing:10];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
