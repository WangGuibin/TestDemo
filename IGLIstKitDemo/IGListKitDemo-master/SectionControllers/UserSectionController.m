//
//  UserSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "UserSectionController.h"
#import "User.h"
#import "DetailLabelCell.h"

@interface UserSectionController ()

@property (nonatomic, strong) User *user;

@end

@implementation UserSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 55);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    DetailLabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[DetailLabelCell class] forSectionController:self atIndex:index];
    
    cell.title = _user.name;
    cell.detail = [@"@" stringByAppendingFormat:@"%@", _user.handle];
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[User class]]) {
        self.user = (User *)object;
    }
}
@end
