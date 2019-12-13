//
//  RemoveCell.h
//  IGListKitDemo
//
//  Created by iOS on 2017/6/28.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemoveCell;

@protocol RemoveCellDelegate <NSObject>

- (void)removeCellDidTapButton:(RemoveCell *)removeCell;

@end

@interface RemoveCell : UICollectionViewCell

@property (nonatomic, weak) id<RemoveCellDelegate> delegate;
@property (nonatomic, copy) NSString *text;

@end
