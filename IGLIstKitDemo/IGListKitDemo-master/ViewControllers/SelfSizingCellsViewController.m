//
//  SelfSizingCellsViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SelfSizingCellsViewController.h"
#import <IGListKit.h>
#import "SelectionModel.h"
#import "SelfSizingSectionController.h"

@interface SelfSizingCellsViewController () <IGListAdapterDataSource>

@end

@implementation SelfSizingCellsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self];
    
    self.datas = @[
                   [SelectionModel selectionModelWithOptions:@[@"Leverage agile", @"frameworks", @"robust synopsis", @"high level", @"overviews", @"Iterative approaches", @"corporate strategy", @"foster collaborative", @"overall value", @"proposition", @"Organically grow", @"holistic world view", @"disruptive", @"innovation", @"workplace diversity", @"empowerment"]],
                   [SelectionModel selectionModelWithOptions:@[@"Bring to the table", @"win-win", @"survival", @"strategies", @"proactive domination", @"At the end of the day", @"going forward", @"a new normal", @"evolved", @"generation X", @"runway heading", @"streamlined", @"cloud solution", @"User generated", @"content", @"in real-time", @"multiple touchpoints", @"offshoring"] type:SelectionModelTypeNib],
                   [SelectionModel selectionModelWithOptions:@[@"Aenean lacinia bibendum nulla sed consectetur. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras mattis consectetur purus sit amet fermentum.", @"Donec sed odio dui. Donec id elit non mi porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed posuere consectetur est at lobortis. Cras justo odio, dapibus ac facilisis in, egestas eget quam.", @"Sed posuere consectetur est at lobortis. Nullam quis risus eget urna mollis ornare vel eu leo. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.", @"12345678"] type:SelectionModelTypeFullWidth]
                   ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:0.831372549 green:0.945098039 blue:0.964705882 alpha:1]];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)(self.collectionView.collectionViewLayout);
    layout.estimatedItemSize = CGSizeMake(100, 40);

    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.datas;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    SelfSizingSectionController *sc = [[SelfSizingSectionController alloc] init];
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}


@end
