//
//  DisplaySectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "DisplaySectionController.h"
#import "LabelCell.h"

@interface DisplaySectionController () <IGListDisplayDelegate>

@end

@implementation DisplaySectionController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.displayDelegate = self;
        self.inset = UIEdgeInsetsMake(0, 0, 30, 0);
    }
    return self;
}

- (NSInteger)numberOfItems {
    return 4;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 55);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LabelCell class] forSectionController:self atIndex:index];
    cell.text = [@"Section " stringByAppendingFormat:@"%ld, cell %ld", self.section, index];
    return cell;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"didSelect section:%ld  row:%ld",self.section,index);
}

- (void)didDeselectItemAtIndex:(NSInteger)index {
    NSLog(@"didDeselect section:%ld  row:%ld",self.section,index);
}

#pragma mark - IGListDisplayDelegate
- (void)listAdapter:(IGListAdapter *)listAdapter willDisplaySectionController:(IGListSectionController *)sectionController {
    NSLog(@"Will display section %ld", sectionController.section);
}

- (void)listAdapter:(IGListAdapter *)listAdapter willDisplaySectionController:(IGListSectionController *)sectionController cell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    NSLog(@"Did will display cell %ld in section %ld", index, sectionController.section);
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingSectionController:(IGListSectionController *)sectionController {
    NSLog(@"Did end display section %ld", sectionController.section);
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingSectionController:(IGListSectionController *)sectionController cell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    NSLog(@"Did end displaying cell %ld in section %ld", index, sectionController.section);
}
@end
