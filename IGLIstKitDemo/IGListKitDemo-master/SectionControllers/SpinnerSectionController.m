//
//  SpinnerSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/28.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SpinnerSectionController.h"
#import "SpinnerCell.h"

@implementation SpinnerSectionController

+ (IGListSingleSectionController *)instance {
    return [[IGListSingleSectionController alloc] initWithCellClass:[SpinnerCell class] configureBlock:^(id  _Nonnull item, __kindof UICollectionViewCell * _Nonnull cell) {
        if ([cell isKindOfClass:[SpinnerCell class]]) {
            [((SpinnerCell *)cell).activityIndicator startAnimating];
        }
    } sizeBlock:^CGSize(id  _Nonnull item, id<IGListCollectionContext>  _Nullable collectionContext) {
        return CGSizeMake(collectionContext.containerSize.width, 100);
    }];
}
@end
