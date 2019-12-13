//
//  SearchViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SearchViewController.h"
#import <IGListKit.h>
#import "SearchSectionCotroller.h"
#import "LabelSectionController.h"

@interface SearchViewController () <IGListAdapterDataSource, SearchSectionCotrollerDelegate>

@property (nonatomic, assign) NSInteger searchToken;
@property (nonatomic, copy) NSString *filterString;

@property (nonatomic, strong) NSSet *words;

@end

@implementation SearchViewController

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
    
    self.searchToken = 42;
    self.filterString = @"";
    
    NSString *str = @"Humblebrag skateboard tacos viral small batch blue bottle, schlitz fingerstache etsy squid. Listicle tote bag helvetica XOXO literally, meggings cardigan kickstarter roof party deep v selvage scenester venmo truffaut. You probably haven't heard of them fanny pack austin next level 3 wolf moon. Everyday carry offal brunch 8-bit, keytar banjo pinterest leggings hashtag wolf raw denim butcher. Single-origin coffee try-hard echo park neutra, cornhole banh mi meh austin readymade tacos taxidermy pug tattooed. Cold-pressed +1 ethical, four loko cardigan meh forage YOLO health goth sriracha kale chips. Mumblecore cardigan humblebrag, lo-fi typewriter truffaut leggings health goth.";
    NSMutableSet *mwords = [[NSMutableSet alloc] init];
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [mwords addObject:substring];
    }];
    
    self.words = [mwords copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    
    NSMutableArray *objects = [@[] mutableCopy];
    [objects addObject:@(self.searchToken)];
    
    if ([self.filterString isEqualToString:@""]) {
        [objects addObjectsFromArray:[self.words allObjects]];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.filterString];
        NSArray *temp = [self.words.allObjects filteredArrayUsingPredicate:predicate];
        [objects addObjectsFromArray:temp];
    }
    
    return [objects copy];
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    
    if ([object isKindOfClass:[NSNumber class]]) {
        SearchSectionCotroller *sc = [[SearchSectionCotroller alloc] init];
        sc.delegate = self;
        return sc;
    } else {
        return [[LabelSectionController alloc] init];
    }
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - SearchSectionCotrollerDelegate
- (void)searchSectionController:(SearchSectionCotroller *)searchSectionController didChangeText:(NSString *)text {
    self.filterString = text;
    [self.adapter performUpdatesAnimated:YES completion:nil];
}
@end
