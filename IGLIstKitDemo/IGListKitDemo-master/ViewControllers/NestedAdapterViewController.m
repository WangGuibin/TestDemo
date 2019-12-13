//
//  NestedAdapterViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "NestedAdapterViewController.h"
#import <IGListKit.h>
#import "HorizontalSectionController.h"
#import "LabelSectionController.h"

@interface NestedAdapterViewController () <IGListAdapterDataSource>

@end

@implementation NestedAdapterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    
    IGListAdapterUpdater *adapterUpdater = [[IGListAdapterUpdater alloc] init];
    self.adapter = [[IGListAdapter alloc] initWithUpdater:adapterUpdater viewController:self];
    
    self.datas = @[
                   @"Ridiculus Elit Tellus Purus Aenean",
                   @"Condimentum Sollicitudin Adipiscing",
                   @14,
                   @"Ligula Ipsum Tristique Parturient Euismod",
                   @"Purus Dapibus Vulputate",
                   @6,
                   @"Tellus Nibh Ipsum Inceptos",
                   @2
                   ];
    
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
    
    if ([object isKindOfClass:[NSNumber class]]) {
        return [[HorizontalSectionController alloc] init];
    } else {
        return [[LabelSectionController alloc] init];
    }
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}
@end
