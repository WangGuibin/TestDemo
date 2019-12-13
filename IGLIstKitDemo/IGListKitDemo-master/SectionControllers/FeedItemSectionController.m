//
//  FeedItemSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "FeedItemSectionController.h"
#import "FeedItem.h"
#import "LabelCell.h"
#import "UserHeaderView.h"

@interface FeedItemSectionController () <IGListSupplementaryViewSource>

@property (nonatomic, strong) FeedItem *feedItem;

@end


@implementation FeedItemSectionController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.supplementaryViewSource = self;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return self.feedItem.comments.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 55);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LabelCell class] forSectionController:self atIndex:index];
    cell.text = self.feedItem.comments[index];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[FeedItem class]]) {
        self.feedItem = (FeedItem *)object;
    }
}

#pragma mark - IGListSupplementaryViewSource
- (NSArray<NSString *> *)supportedElementKinds {
    return @[UICollectionElementKindSectionHeader];
}

- (UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind atIndex:(NSInteger)index {
    UserHeaderView *view = [self.collectionContext dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader forSectionController:self nibName:@"UserHeaderView" bundle:nil atIndex:index];
    view.handle = [@"@" stringByAppendingString:self.feedItem.user.handle];
    view.name = self.feedItem.user.name;
    return view;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind atIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 40);
}
@end
