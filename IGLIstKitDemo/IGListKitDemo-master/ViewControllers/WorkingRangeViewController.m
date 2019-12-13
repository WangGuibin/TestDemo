//
//  WorkingRangeViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/30.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "WorkingRangeViewController.h"
#import <IGListKit.h>
#import "WorkingRangeSectionController.h"

@interface WorkingRangeViewController () <IGListAdapterDataSource>

@end

@implementation WorkingRangeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self workingRangeSize:2];
    
    NSMutableSet *set = [[NSMutableSet alloc] init];
    while (set.count < 20) {
        NSInteger intt = (NSInteger)arc4random_uniform(200) + 200;
        [set addObject:[NSNumber numberWithInteger:intt]];
    }
    self.datas = [set allObjects];
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
    WorkingRangeSectionController *sc = [[WorkingRangeSectionController alloc] init];
    
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
