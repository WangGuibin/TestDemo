//
//  GridSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "GridSectionController.h"
#import "GridItem.h"
#import "CenterLabelCell.h"

@interface GridSectionController ()

@property (nonatomic, strong) GridItem *object;

@end

@implementation GridSectionController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 1;
        self.minimumInteritemSpacing = 1;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return _object.itemCount;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    CGFloat itemSize = floorf(width/4);
    return CGSizeMake(itemSize, itemSize);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    CenterLabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[CenterLabelCell class] forSectionController:self atIndex:index];
    cell.text = [@"" stringByAppendingFormat:@"%ld", index+1];
    [cell setBackgroundColor:_object.color];
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[GridItem class]]) {
        self.object = object;
    }
}
@end
