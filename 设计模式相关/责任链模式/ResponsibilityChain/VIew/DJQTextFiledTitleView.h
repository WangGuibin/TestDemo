//
//  DJQTextFiledTitleView.h
//  DJQ_iOS_Service
//
//  Created by neotv-- on 2018/6/23.
//  Copyright © 2018年 NEOTV. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DJQTextFiledTitleView : UIView

@property (nonatomic, strong) NSString    *title;
@property (nonatomic, strong) NSString    *placeHolder;

@property (nonatomic, assign) NSInteger minLength, maxLength;

@property (nonatomic, strong) UITextField *field;

@property (nonatomic, strong) NSIndexPath *indexPath;
/**存哪一个字段*/
@property (nonatomic, strong) NSString *modelDicKey;
/**存到list数据中第几个位置*/
@property (nonatomic, strong) NSString *teamMemberSeq;


@end
