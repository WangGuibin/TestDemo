//
//  LabelSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/28.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "LabelSectionController.h"
#import "LabelCell.h"

@interface LabelSectionController ()

@property (nonatomic, copy) NSString *object;

@end

@implementation LabelSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 55);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LabelCell class] forSectionController:self atIndex:index];
    
    cell.text = _object;
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.object = [object description];
}
@end
