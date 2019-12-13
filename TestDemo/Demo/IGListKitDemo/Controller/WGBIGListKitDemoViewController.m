//
// WGBIGListKitDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/12
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
    

#import "WGBIGListKitDemoViewController.h"
#import "IGListDemoItemModel.h"
#import "IGListDemoListSection.h"
#import "WGBSingleLabelTextCellDemoVC.h"
#import "WGBPostFeedListDemoVC.h"

@interface WGBIGListKitDemoViewController ()<IGListAdapterDataSource>


@end

@implementation WGBIGListKitDemoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup {
    self.title = @"IGListKit Demos";
    IGListAdapterUpdater *adapterUpdater = [[IGListAdapterUpdater alloc] init];
    self.adapter = [[IGListAdapter alloc] initWithUpdater:adapterUpdater viewController:self];
    self.dataSource = @[
               [IGListDemoItemModel DemoItemWithName:@"Demo列表" controllerClass:[WGBSingleLabelTextCellDemoVC class]],
               [IGListDemoItemModel DemoItemWithName:@"高仿instram列表demo" controllerClass:[WGBPostFeedListDemoVC class]],

               ];
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataSource;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [[IGListDemoListSection alloc] init];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}


@end
