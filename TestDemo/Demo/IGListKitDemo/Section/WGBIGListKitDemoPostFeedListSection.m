//
// WGBIGListKitDemoPostFeedListSection.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/13
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "WGBIGListKitDemoPostFeedListSection.h"
#import "WGBPostItemModel.h"
#import "WGBCommentCell.h"
#import "WGBPhotoCell.h"
#import "WGBInteractiveCell.h"
#import "WGBUserInfoCell.h"

static NSInteger cellsBeforeComments = 3;

@interface WGBIGListKitDemoPostFeedListSection()

@property (nonatomic,strong) WGBPostItemModel *postItem;

@end

@implementation WGBIGListKitDemoPostFeedListSection

#pragma mark - IGListSectionController Overrides
- (NSInteger)numberOfItems{
    return cellsBeforeComments + self.postItem.comments.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    const CGFloat width = self.collectionContext.containerSize.width;
    CGFloat height;
    if (index == 0 || index == 2) {
        height = 41.0;
    } else if (index == 1) {
        height = width; // square
    } else {
        height = 25.0;
    }
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass;
    if (index == 0) {
        cellClass = [WGBUserInfoCell class];
    } else if (index == 1) {
        cellClass = [WGBPhotoCell class];
    } else if (index == 2) {
        cellClass = [WGBInteractiveCell class];
    } else {
        cellClass = [WGBCommentCell class];
    }
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
    if ([cell isKindOfClass:[WGBCommentCell class]]) {
        [(WGBCommentCell *)cell setComment:self.postItem.comments[index - cellsBeforeComments]];
    } else if ([cell isKindOfClass:[WGBUserInfoCell class]]) {
        [(WGBUserInfoCell *)cell setName: self.postItem.username];
    }
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.postItem = object;
}



@end
