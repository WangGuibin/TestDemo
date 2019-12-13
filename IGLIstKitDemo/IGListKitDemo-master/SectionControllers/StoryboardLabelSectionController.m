//
//  StoryboardLabelSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "StoryboardLabelSectionController.h"
#import "Person.h"
#import "StoryboardCell.h"

@interface StoryboardLabelSectionController ()

@property (nonatomic, strong) Person *object;

@end

@implementation StoryboardLabelSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.object.name.length * 7, self.object.name.length * 7);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    StoryboardCell *cell = [self.collectionContext dequeueReusableCellFromStoryboardWithIdentifier:@"cell" forSectionController:self atIndex:index];
    cell.text = self.object.name;
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[Person class]]) {
        self.object = object;
    }
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeSectionControllerWantsRemoved:)]) {
        [self.delegate removeSectionControllerWantsRemoved:self];
    }
}
@end
