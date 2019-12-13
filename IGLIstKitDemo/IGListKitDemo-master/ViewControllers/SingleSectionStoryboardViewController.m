//
//  SingleSectionStoryboardViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SingleSectionStoryboardViewController.h"
#import <IGListKit.h>
#import "NSArray+Number.h"
#import "StoryboardCell.h"

@interface SingleSectionStoryboardViewController () <IGListAdapterDataSource, IGListSingleSectionControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation SingleSectionStoryboardViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self];
    
    self.datas = [NSArray arrayWithNumber:@(20)];
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
    IGListSingleSectionController *sc = [[IGListSingleSectionController alloc] initWithStoryboardCellIdentifier:@"cell" configureBlock:^(id  _Nonnull item, __kindof UICollectionViewCell * _Nonnull cell) {
        
        StoryboardCell *ccell = (StoryboardCell *)cell;
        ccell.text = [@"Cell: " stringByAppendingFormat:@"%ld", [item integerValue] + 1];
        
    } sizeBlock:^CGSize(id  _Nonnull item, id<IGListCollectionContext>  _Nullable collectionContext) {
        return CGSizeMake(collectionContext.containerSize.width, 44);
    }];
    
    sc.selectionDelegate = self;
    
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - IGListSingleSectionControllerDelegate
- (void)didSelectSectionController:(IGListSingleSectionController *)sectionController withObject:(id)object {
    NSInteger section = [self.adapter sectionForSectionController:sectionController] + 1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[@"Section " stringByAppendingFormat:@"%ld was selected ", section] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
