//
//  SupplementaryViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SupplementaryViewController.h"
#import <IGListKit.h>
#import "FeedItem.h"
#import "FeedItemSectionController.h"

@interface SupplementaryViewController () <IGListAdapterDataSource>

@end

@implementation SupplementaryViewController

// collectionView 自定义组头组尾实现

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
                   [FeedItem feedItemWithPk:1 user:[User userWithPk:100 name:@"Jesse" handle:@"jesse_squires"] comments:@[@"You rock!", @"Hmm you sure about that?"]],
                   [FeedItem feedItemWithPk:2 user:[User userWithPk:101 name:@"Ryan" handle:@"_ryannystrom"] comments:@[@"lgtm", @"lol", @"Let's try it!"]],
                   [FeedItem feedItemWithPk:3 user:[User userWithPk:102 name:@"Ann" handle:@"abaum"] comments:@[@"Good luck!"]],
                   [FeedItem feedItemWithPk:4 user:[User userWithPk:103 name:@"Phil" handle:@"phil"] comments:@[@"yoooooooo", @"What's the eta?"]],
                   ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.datas;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    FeedItemSectionController *sc = [[FeedItemSectionController alloc] init];
    
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}
@end
