
//
//  HorizontalSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "HorizontalSectionController.h"
#import "EmbeddedCollectionViewCell.h"
#import "EmbeddedSectionController.h"
#import "NSArray+Number.h"

@interface HorizontalSectionController () <IGListAdapterDataSource>

@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) IGListAdapter *adapter;

@end

@implementation HorizontalSectionController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self.viewController];
        [self.adapter setDataSource:self];
    }
    return self;
}

-(CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 100);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    EmbeddedCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[EmbeddedCollectionViewCell class] forSectionController:self atIndex:index];
    
    self.adapter.collectionView = cell.collectionView;
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[NSNumber class]]) {
        self.number = (NSNumber *)object;
    }
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    
    return [NSArray arrayWithNumber:self.number];
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [[EmbeddedSectionController alloc] init];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    UIView *view = [[UIView alloc] init];
    [view setBounds:CGRectMake(0, 0, 50, 50)];
    [view setBackgroundColor:[UIColor blueColor]];
    return view;
}
@end
