//
//  ObjcDemoViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "ObjcDemoViewController.h"
#import <IGListKit.h>
#import "Post.h"
#import "PostSectionController.h"

@interface ObjcDemoViewController () <IGListAdapterDataSource>

@end

@implementation ObjcDemoViewController

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
                   [Post postWithUserName:@"userA" comments:@[
                                                              @"Luminous triangle",
                                                              @"Awesome",
                                                              @"Super clean",
                                                              @"Stunning shot",
                                                              ]],
                   [Post postWithUserName:@"userB" comments:@[
                                                              @"The simplicity here is superb",
                                                              @"thanks!",
                                                              @"That's always so kind of you!",
                                                              @"I think you might like this",
                                                              ]],
                   [Post postWithUserName:@"userC" comments:@[
                                                              @"So good",
                                                              ]],
                   [Post postWithUserName:@"userD" comments:@[
                                                              @"hope she might like it.",
                                                              @"I love it."
                                                              ]]
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
    PostSectionController *sc = [[PostSectionController alloc] init];
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
