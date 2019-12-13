//
//  StackedViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "StackedViewController.h"
#import <IGListKit.h>
#import "WorkingRangeSectionController.h"
#import "DisplaySectionController.h"
#import "HorizontalSectionController.h"

@interface StackedViewController () <IGListAdapterDataSource>

@end

@implementation StackedViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self workingRangeSize:1];
    
    self.datas = @[@(128),@(256),@(64)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.datas;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    IGListStackedSectionController *sc = [[IGListStackedSectionController alloc]
                                          initWithSectionControllers:@[
                                                                       [[WorkingRangeSectionController alloc] init],
                                                                       [[DisplaySectionController alloc] init],
                                                                       [[HorizontalSectionController alloc] init]
                                                                       ]];
    sc.inset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
