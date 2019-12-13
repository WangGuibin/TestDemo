//
//  PostSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "PostSectionController.h"
#import "Post.h"
#import "UserInfoCell.h"
#import "PhotoCell.h"
#import "CommentCell.h"
#import "InteractiveCell.h"

static NSInteger cellsBeforeComments = 3;

@implementation PostSectionController {
    Post *_post;
}

- (NSInteger)numberOfItems {
    return cellsBeforeComments + _post.comments.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    const CGFloat width = self.collectionContext.containerSize.width;
    CGFloat height;
    if (index == 0 || index == 2) {
        height = 41.0;
    } else if (index == 1) {
        height = width;
    } else {
        height = 25.0;
    }
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass;
    
    if (index == 0) {
        cellClass = [UserInfoCell class];
    } else if (index == 1) {
        cellClass = [PhotoCell class];
    } else if (index == 2) {
        cellClass = [InteractiveCell class];
    } else {
        cellClass = [CommentCell class];
    }
    
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
    if ([cell isKindOfClass:[CommentCell class]]) {
        [(CommentCell *)cell setComment:_post.comments[index-cellsBeforeComments]];
    } else if ([cell isKindOfClass:[UserInfoCell class]]) {
        [(UserInfoCell *)cell setName:_post.userName];
    }
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[Post class]]) {
        _post = object;
    }
}
@end
