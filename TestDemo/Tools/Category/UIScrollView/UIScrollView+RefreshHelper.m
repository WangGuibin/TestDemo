//
// UIScrollView+RefreshHelper.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/7/24
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
    

#import "UIScrollView+RefreshHelper.h"
#import <MJRefresh.h>

@implementation UIScrollView (RefreshHelper)

//添加mj_header 默认MJRefreshNormalHeader
- (void)addRefreshHeaderWithTarget:(id)target action:(SEL)sel{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:sel];
}

//添加mj_footer 默认 MJRefreshBackNormalFooter
- (void)addRefreshFooterWithTarget:(id)target action:(SEL)sel{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:sel];
}

//结束刷新
- (void)endRefreshing{
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}

//结束刷新并设置mj_footer没有更多数据状态
- (void)endRefreshingWithNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

//下拉刷新之后重置mj_footer没有更多数据状态
- (void)resetNoMoreData{
    [self.mj_footer resetNoMoreData];
}


@end
