//
//  WorkingRangeSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/30.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "WorkingRangeSectionController.h"
#import "LabelCell.h"
#import "ImageCell.h"

@interface WorkingRangeSectionController () <IGListWorkingRangeDelegate>

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) UIImage *downloadedImage;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, copy) NSString *urlString;

@end

@implementation WorkingRangeSectionController

- (NSString *)urlString {

    NSInteger height = _height;
    CGFloat width = self.collectionContext.containerSize.width;
    return [@"https://picsum.photos/" stringByAppendingFormat:@"%.1f/%ld", width, height];
}

- (void)dealloc {
    [self.task cancel];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.workingRangeDelegate = self;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return 2;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    CGFloat height = index == 0 ? 55 : _height;
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    
    Class cellClass = index == 0 ? [LabelCell class] : [ImageCell class];
    UICollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
    
    if ([cell isKindOfClass:[LabelCell class]]) {
        ((LabelCell *)cell).text = self.urlString;
    } else {
        ((ImageCell *)cell).image = _downloadedImage;
    }
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[NSNumber class]]) {
        self.height = [(NSNumber *)object integerValue];
    }
}

#pragma mark - IGListWorkingRangeDelegate

- (void)listAdapter:(IGListAdapter *)listAdapter sectionControllerWillEnterWorkingRange:(IGListSectionController *)sectionController {
    self.downloadedImage = nil;
    self.task = nil;
    NSString *urlString = self.urlString;
    if (urlString.length == 0) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.downloadedImage = image;
                ImageCell *cell = [self.collectionContext cellForItemAtIndex:1 sectionController:self];
                [cell setImage:image];
            });
        } else {
            NSLog(@"下载出错 %@: %@", self.urlString, [error localizedDescription]);
        }
    }];
    [self.task resume];
}

- (void)listAdapter:(IGListAdapter *)listAdapter sectionControllerDidExitWorkingRange:(IGListSectionController *)sectionController {
}
@end
