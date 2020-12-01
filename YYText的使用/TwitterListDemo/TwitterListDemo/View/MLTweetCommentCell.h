//
//  MLTweetCommentCell.h
//  MeiLin
//
//  Created by 曹学亮 on 2016/10/10.
//  Copyright © 2016年 Li Chuanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLTweetModel,TweetCommentModel;
@interface MLTweetCommentCell : UITableViewCell
@property (nonatomic,strong) TweetCommentModel *commentModel;
+ (CGFloat)cellHeightWithModel:(TweetCommentModel*)model;
@property (nonatomic,copy) void(^DidClickedUserName)(TweetCommentModel *commentModel);
@property (nonatomic,copy) void(^DidClickedReplyUserName)(NSString *member_id);
@property (nonatomic,copy) void(^DidClickedLink)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect);
@end
