//
//  AnnouncingDepsViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "AnnouncingDepsViewController.h"
#import <IGListKit.h>
#import "NSArray+Number.h"
#import "IncrementAnnouncer.h"
#import "ListeningSectionController.h"

@interface AnnouncingDepsViewController () <IGListAdapterDataSource>

@property (nonatomic, strong) IncrementAnnouncer *announcer;

@end

@implementation AnnouncingDepsViewController

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
    
    self.datas = [NSArray arrayWithNumber:@20];
    self.announcer = [[IncrementAnnouncer alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
}

- (void)onAdd {
    [self.announcer increment];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.datas;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    ListeningSectionController *sc = [[ListeningSectionController alloc] initWithAnnouncer:self.announcer];
    
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
