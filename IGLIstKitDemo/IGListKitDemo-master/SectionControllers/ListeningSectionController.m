//
//  ListeningSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "ListeningSectionController.h"
#import "LabelCell.h"

@interface ListeningSectionController () <IGListDisplayDelegate>

@end
@implementation ListeningSectionController {
    NSInteger _value;
}

- (instancetype)initWithAnnouncer:(IncrementAnnouncer *)announcer
{
    self = [super init];
    if (self) {
        self.displayDelegate = self;
        [announcer addListener:self];
    }
    return self;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 55);
}

- (void)configureCell:(LabelCell *)cell {
    cell.text = [@"Section: " stringByAppendingFormat:@"%ld, value: %ld", self.section, _value];
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LabelCell class] forSectionController:self atIndex:index];
    [self configureCell:cell];
    
    return cell;
}

- (void)didIncrement:(IncrementAnnouncer *)announcer value:(NSInteger)value {
    _value = value;
    LabelCell *cell = [self.collectionContext cellForItemAtIndex:0 sectionController:self];
    if (cell) {
        [self configureCell:cell];
    }
}

#pragma mark - IGListDisplayDelegate
- (void)listAdapter:(IGListAdapter *)listAdapter willDisplaySectionController:(IGListSectionController *)sectionController {
    NSLog(@"将要显示 section %ld", sectionController.section);
}

- (void)listAdapter:(IGListAdapter *)listAdapter willDisplaySectionController:(IGListSectionController *)sectionController cell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    NSLog(@"将要显示 cell %ld in section %ld", index, sectionController.section);
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingSectionController:(IGListSectionController *)sectionController {
    NSLog(@"Did end display section %ld", sectionController.section);
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingSectionController:(IGListSectionController *)sectionController cell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    NSLog(@"Did end displaying cell %ld in section %ld", index, sectionController.section);
}
@end
