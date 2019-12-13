//
//  EmbeddedSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "EmbeddedSectionController.h"
#import "CenterLabelCell.h"

@interface EmbeddedSectionController ()

@property (nonatomic, strong) NSNumber *number;

@end

@implementation EmbeddedSectionController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inset = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    return self;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat height = self.collectionContext.containerSize.height;
    return CGSizeMake(height, height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    CenterLabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[CenterLabelCell class] forSectionController:self atIndex:index];
    [cell setText:[NSString stringWithFormat:@"%ld", [_number integerValue]+1]];
    [cell setBackgroundColor:[UIColor colorWithRed:237/255.0 green:73/255.0 blue:86/255.0 alpha:1]];
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[NSNumber class]]) {
        self.number = (NSNumber *)object;
    }
}
@end
