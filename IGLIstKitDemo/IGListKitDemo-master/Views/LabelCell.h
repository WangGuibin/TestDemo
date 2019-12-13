//
//  LabelCell.h
//  IGListKitDemo
//
//  Created by iOS on 2017/6/27.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit.h>

@interface LabelCell : UICollectionViewCell <IGListBindable>

@property (nonatomic, copy) NSString *text;

@end
