//
//  DemosViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/27.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "DemosViewController.h"
#import <IGListKit.h>
#import "DemoSectionController.h"
#import "LoadMoreViewController.h"
#import "SearchViewController.h"
#import "MixedDataViewController.h"
#import "EmptyViewController.h"
#import "NestedAdapterViewController.h"
#import "SingleSectionViewController.h"
#import "StoryboardViewController.h"
#import "SingleSectionStoryboardViewController.h"
#import "WorkingRangeViewController.h"
#import "DiffTableViewController.h"
#import "SupplementaryViewController.h"
#import "SelfSizingCellsViewController.h"
#import "DisplayViewController.h"
#import "StackedViewController.h"
#import "ObjcDemoViewController.h"
#import "CalendarViewController.h"
#import "AnnouncingDepsViewController.h"

@interface DemosViewController () <IGListAdapterDataSource>

@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<DemoItem *> *demos;

@end

@implementation DemosViewController

- (void)initSetup {
    self.title = @"Demos";
    
    IGListAdapterUpdater *adapterUpdater = [[IGListAdapterUpdater alloc] init];
    _adapter = [[IGListAdapter alloc] initWithUpdater:adapterUpdater viewController:self];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    _demos = @[
               [DemoItem DemoItemWithName:@"尾部加载" controllerClass:[LoadMoreViewController class]],
               [DemoItem DemoItemWithName:@"自动搜索" controllerClass:[SearchViewController class]],
               [DemoItem DemoItemWithName:@"混合数据" controllerClass:[MixedDataViewController class]],
               [DemoItem DemoItemWithName:@"嵌套的适配器" controllerClass:[NestedAdapterViewController class]],
               [DemoItem DemoItemWithName:@"空视图" controllerClass:[EmptyViewController class]],
               [DemoItem DemoItemWithName:@"单节控制器" controllerClass:[SingleSectionViewController class]],
               [DemoItem DemoItemWithName:@"Storyboard" controllerClass:[StoryboardViewController class] controllerIdentifier:@"demo"],
               [DemoItem DemoItemWithName:@"Single Section Storyboard" controllerClass:[SingleSectionStoryboardViewController class] controllerIdentifier:@"singleSectionDemo"],
               [DemoItem DemoItemWithName:@"工作范围" controllerClass:[WorkingRangeViewController class]],
               [DemoItem DemoItemWithName:@"Diff算法" controllerClass:[DiffTableViewController class]],
               [DemoItem DemoItemWithName:@"补充视图" controllerClass:[SupplementaryViewController class]],
               [DemoItem DemoItemWithName:@"Self-sizing cells" controllerClass:[SelfSizingCellsViewController class]],
               [DemoItem DemoItemWithName:@"Display delegate" controllerClass:[DisplayViewController class]],
               [DemoItem DemoItemWithName:@"Stacked Section Controllers" controllerClass:[StackedViewController class]],
               [DemoItem DemoItemWithName:@"Objc Demo" controllerClass:[ObjcDemoViewController class]],
               [DemoItem DemoItemWithName:@"Calendar (auto diffing)" controllerClass:[CalendarViewController class]],
               [DemoItem DemoItemWithName:@"Dependency Injection" controllerClass:[AnnouncingDepsViewController class]]
               ];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.demos;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [[DemoSectionController alloc] init];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
