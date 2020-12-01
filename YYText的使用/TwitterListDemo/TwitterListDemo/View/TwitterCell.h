//
//  TwitterCell.h
//  TwitterListDemo
//
//  Created by bjovov on 2017/11/28.
//  Copyright © 2017年 Cao Xueliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTableViewCell.h"
#import <YYText/YYText.h>

/**用户信息View*/
@class TwitterCell,MLTweetLayouts,MLTweetModel,TweetCommentModel;
@interface TwitterProfileView : UIView
@property (nonatomic,strong) UIImageView *avatarView;
@property (nonatomic,strong) YYLabel *nameLabel;
@property (nonatomic,strong) YYLabel *locationLabel;
@property (nonatomic,weak)   TwitterCell *cell;
@end


/**视频View*/
@interface TwitterVideoView : UIView
@property (nonatomic,strong) UIButton *videoImageButton;
@property (nonatomic,strong) UIImageView *startImageView;
@property (nonatomic,weak)   TwitterCell *cell;
@end


/**底部工具条*/
@interface TwitterToolbarView : UIView
@property (nonatomic,strong) UIButton *repostButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIButton *likeButton;
@property (nonatomic,strong) UIImageView *repostImageView;
@property (nonatomic,strong) UIImageView *commentImageView;
@property (nonatomic,strong) UIImageView *likeImageView;
@property (nonatomic,strong) YYLabel *repostLabel;
@property (nonatomic,strong) YYLabel *commentLabel;
@property (nonatomic,strong) YYLabel *likeLabel;
@property (nonatomic,strong) CAGradientLayer *line1;
@property (nonatomic,strong) CAGradientLayer *line2;
@property (nonatomic,strong) CALayer *topLine;
@property (nonatomic,strong) CALayer *bottomLine;
@property (nonatomic,weak)   TwitterCell *cell;
@end


/**点赞和喜欢View*/
@interface TwitterLikeOrCommentView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YYLabel *likeUsersLabel;
@property (nonatomic,strong) UITableView *commentTable;
@property (nonatomic,strong) UIImageView *likeBeginImageView;
@property (nonatomic,strong) CALayer *separateLayer;
@property (nonatomic,weak)   TwitterCell *cell;
@property (nonatomic,strong) NSArray *commentArray; 
@end


/**动态View*/
@interface TwitterView : UIView
@property (nonatomic,strong) UIView *contentView;             //容器视图
@property (nonatomic,strong) TwitterProfileView *profileView; //个人信息
@property (nonatomic,strong) YYLabel *textLabel;              //动态label
@property (nonatomic,strong) UIButton *expendButton;          //展开折叠按钮
@property (nonatomic,strong) NSArray<UIView *> *picViews;     //图片数组
@property (nonatomic,strong) TwitterVideoView *videoView;     //视频视图
@property (nonatomic,strong) TwitterLikeOrCommentView *likeOrCommentView; //点赞评论视图
@property (nonatomic,strong) TwitterToolbarView *toolbarView; //工具栏
@property (nonatomic,strong) UIButton *menuButton;            //菜单栏
@property (nonatomic,strong) YYLabel *timeLabel;              //发布时间
@property (nonatomic,strong) MLTweetLayouts *layout;          //布局
@property (nonatomic,weak)   TwitterCell *cell;               //自身cell
@end


/**动态Cell*/
@protocol TwitterCellDelegate;
@interface TwitterCell : YYTableViewCell
@property (nonatomic,weak)   id<TwitterCellDelegate> delegate;
@property (nonatomic,strong) TwitterView *statusView;
- (void)setLayout:(MLTweetLayouts *)layout;
@end


/**点击cell的代理方法*/
@protocol TwitterCellDelegate <NSObject>
@optional

///点击了 Cell
- (void)cellDidClick:(TwitterCell *)cell;

///点击了Cell菜单
- (void)cellDidClickMenu:(TwitterCell *)cell;

///点击了展开收起按钮
- (void)cellDidClickExpendButton:(TwitterCell *)cell;

///点击了视频
- (void)cellDidClickedVideo:(TwitterCell *)cell;

///点击了关注
- (void)cellDidClickFollow:(TwitterCell *)cell;

///点击了转发
- (void)cellDidClickRepost:(TwitterCell *)cell;

//点击了点赞的昵称
- (void)cellDidClickedLikedUser:(TwitterCell *)userModel;

///点击了评论的昵称
- (void)cellDidClickedCommentUser:(TweetCommentModel *)userModel;

///点击了回复人的昵称
- (void)cellDidClickedReplyUser:(NSString *)memberId;

///点击了下方 Tag
- (void)cellDidClickTag:(TwitterCell *)cell;

///点击了评论
- (void)cellDidClickComment:(TwitterCell *)cell;

///评论评论中的内容
- (void)cellDidClickedCommentListCell:(TwitterCell *)cell commentIndex:(NSInteger)index;

///点击了赞
- (void)cellDidClickLike:(TwitterCell *)cell;

///点击了用户
- (void)cell:(TwitterCell *)cell didClickUser:(MLTweetModel *)user;

///点击了图片
- (void)cell:(TwitterCell *)cell didClickImageAtIndex:(NSUInteger)index;

///点击了 Label 的链接
- (void)cell:(TwitterCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end

