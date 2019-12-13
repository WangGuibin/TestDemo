//
//  SelfSizingSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SelfSizingSectionController.h"
#import "SelectionModel.h"
#import "ManuallySelfSizingCell.h"
#import "FullWidthSelfSizingCell.h"
#import "NibSelfSizingCell.h"

@interface SelfSizingSectionController ()

@property (nonatomic, strong) SelectionModel *model;

@end

@implementation SelfSizingSectionController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inset = UIEdgeInsetsMake(0, 0, 40, 0);
        self.minimumLineSpacing = 4;
        self.minimumInteritemSpacing = 4;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return self.model.options.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 55);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    NSString *text = self.model.options[index];
    UICollectionViewCell *cell;
    switch (self.model.type) {
        case SelectionModelTypeNone:
        {
            ManuallySelfSizingCell *manualCell = [self.collectionContext dequeueReusableCellOfClass:[ManuallySelfSizingCell class] forSectionController:self atIndex:index];
            manualCell.text = text;
            cell = manualCell;
        }
            break;
        case SelectionModelTypeFullWidth:
        {
            FullWidthSelfSizingCell *fullWidthCell = [self.collectionContext dequeueReusableCellOfClass:[FullWidthSelfSizingCell class] forSectionController:self atIndex:index];
            fullWidthCell.text = text;
            cell = fullWidthCell;
        }
            break;
        case SelectionModelTypeNib:
        {
            NibSelfSizingCell *nibCell = [self.collectionContext dequeueReusableCellWithNibName:NSStringFromClass([NibSelfSizingCell class]) bundle:nil forSectionController:self atIndex:index];
            nibCell.contentLabel.text = text;
            cell = nibCell;
        }
            break;
    }
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[SelectionModel class]]) {
        self.model = object;
    }
}
@end
