//
//  LoadMoreViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/27.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "LoadMoreViewController.h"
#import <IGListKit.h>
#import "SpinnerSectionController.h"
#import "LabelSectionController.h"
#import "NSArray+Number.h"

@interface LoadMoreViewController () <IGListAdapterDataSource, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, copy) NSString *spinToken;

@end

@implementation LoadMoreViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup {
    
    IGListAdapterUpdater *adapterUpdater = [[IGListAdapterUpdater alloc] init];
    self.adapter = [[IGListAdapter alloc] initWithUpdater:adapterUpdater viewController:self];
    
    
    self.datas = [NSArray arrayWithNumber:@20];
    _loading = NO;
    _spinToken = @"spinner";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
    [self.adapter setScrollViewDelegate:self];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    
    NSArray *objects = self.datas;
    
    if (_loading) {
        objects = [self.datas arrayByAddingObject:_spinToken];
    }
    
    return objects;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    
    if ([object isKindOfClass:[NSString class]] && [(NSString *)object isEqualToString:_spinToken]) {
        return [SpinnerSectionController instance];
    } else {
        return [[LabelSectionController alloc] init];
    }
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat distance = scrollView.contentSize.height - (targetContentOffset->y + scrollView.bounds.size.height);
    
    if (!_loading && distance < 200) {
        self.loading = YES;
        
        [self.adapter performUpdatesAnimated:YES completion:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                NSUInteger itemCount = self.datas.count;
                self.datas = [self.datas arrayByAddingObjectsFromArray:[NSArray arrayWithFrom:itemCount to:itemCount+5]];
                [self.adapter performUpdatesAnimated:YES completion:nil];
            });
        });
    }
}


@end
