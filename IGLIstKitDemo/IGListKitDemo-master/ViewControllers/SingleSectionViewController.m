//
//  SingleSectionViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SingleSectionViewController.h"
#import <IGListKit.h>
#import "NSArray+Number.h"
#import "NibCell.h"

@interface SingleSectionViewController () <IGListAdapterDataSource, IGListSingleSectionControllerDelegate>

@end

@implementation SingleSectionViewController

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
    
    self.datas = [NSArray arrayWithNumber:@20];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.datas;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    
    IGListSingleSectionController *sectionController = [[IGListSingleSectionController alloc] initWithNibName:@"NibCell" bundle:nil configureBlock:^(id  _Nonnull item, __kindof UICollectionViewCell * _Nonnull cell) {
        
        if ([cell isKindOfClass:[NibCell class]]) {
            NibCell *ccell = (NibCell *)cell;
            
            if ([item isKindOfClass:[NSNumber class]]) {
                NSInteger number = [(NSNumber *)item integerValue];
                ccell.text = [@"Cell: " stringByAppendingFormat:@"%ld", number+1];
            }
        }
    } sizeBlock:^CGSize(id  _Nonnull item, id<IGListCollectionContext>  _Nullable collectionContext) {
        
        return CGSizeMake(collectionContext.containerSize.width, 44);
    }];
    [sectionController setSelectionDelegate:self];
    
    return sectionController;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - IGListSingleSectionControllerDelegate
- (void)didSelectSectionController:(IGListSingleSectionController *)sectionController withObject:(id)object {
    NSInteger section = [self.adapter sectionForSectionController:sectionController] + 1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[@"Section " stringByAppendingFormat:@"%ld was seleted 🎉", section] message:[@"Cell Object: " stringByAppendingFormat:@"%@", [object description]] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
