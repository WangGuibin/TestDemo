//
//  EmptyViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/28.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "EmptyViewController.h"
#import <IGListKit.h>
#import "RemoveSectionController.h"

@interface EmptyViewController () <IGListAdapterDataSource, RemoveSectionControllerDelegate>

@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, assign) NSInteger tally;
@end

@implementation EmptyViewController

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
    
    self.tally = 4;
    self.datas = @[@1, @2, @3, @4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    
    [self.collectionView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        [_emptyLabel setNumberOfLines:0];
        [_emptyLabel setTextAlignment:NSTextAlignmentCenter];
        [_emptyLabel setBackgroundColor:[UIColor clearColor]];
        [_emptyLabel setText:@"没有更多数据了!"];
    }
    return _emptyLabel;
}

- (void)onAdd {
    self.datas = [self.datas arrayByAddingObject:[NSNumber numberWithInteger:(_tally+1)]];
    self.tally++;
    [self.adapter performUpdatesAnimated:YES completion:nil];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return [self.datas copy];
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    RemoveSectionController *sc = [[RemoveSectionController alloc] init];
    [sc setDelegate:self];
    
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return self.emptyLabel;
}

#pragma mark - RemoveSectionControllerDelegate
- (void)removeSectionControllerWantsRemoved:(RemoveSectionController *)removeSectionController {
    NSInteger section = [self.adapter sectionForSectionController:removeSectionController];
    NSNumber *object = [self.adapter objectAtSection:section];
    
    NSMutableArray *datas = [self.datas mutableCopy];
    [datas removeObject:object];
    self.datas = [datas copy];
    
    [self.adapter performUpdatesAnimated:YES completion:nil];
}
@end
