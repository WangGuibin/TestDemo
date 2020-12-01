//
//  MLTweetModel.h
//  MeiLin
//
//  Created by 曹学亮 on 16/10/8.
//  Copyright © 2016年 Li Chuanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 一张图片Model
 */
@interface TweetPictureModel : NSObject
@property (nonatomic,copy) NSString *images_big;   //大图
@property (nonatomic,copy) NSString *images_small; //缩略图
@property (nonatomic,assign) CGFloat ico_width;    //宽度
@property (nonatomic,assign) CGFloat ico_height;   //高度
@end


/**
 一个视频Model
 */
@interface TweetVideoModel : NSObject
@property (nonatomic,copy) NSString *video_file;  //视频连接
@property (nonatomic,copy) NSString *video_img;   //视频缩略图
@property (nonatomic,copy) NSString *video_time;  //视频时间
@end


/**
 一个语音Model
 */
@interface TweetVoiceModel : NSObject
@property (nonatomic,copy) NSString *voice_file;  //语音链接
@property (nonatomic,copy) NSString *voice_time;  //语音时长
@end


/**
 评论Model
 */
@interface TweetCommentModel : NSObject
@property (nonatomic,copy) NSString *avatar;          //评论者头像
@property (nonatomic,copy) NSString *comment;         //评论内容
@property (nonatomic,copy) NSString *member_id;       //用户id
@property (nonatomic,copy) NSString *news_id;         //新闻id
@property (nonatomic,copy) NSString *newscom_id;      //评论id
@property (nonatomic,copy) NSString *nick_name;       //昵称
@property (nonatomic,copy) NSString *post_location;   //评论地点
@property (nonatomic,copy) NSString *post_time;       //评论时间
@property (nonatomic,copy) NSString *sex;             //性别
@property (nonatomic,copy) NSString *is_my_reply;     //是否是我评论的
@property (nonatomic,copy) NSString *is_replay;       //是否是回复用户
@property (nonatomic,copy) NSString *re_nick_name;    //被回复人的昵称
@property (nonatomic,copy) NSString *reply_member_id; //被回复人的id
@end


/**
 点赞model
 */
@interface TweetLikeModel : NSObject
@property (nonatomic,copy) NSString *avatar;     //点赞头像
@property (nonatomic,copy) NSString *member_id;  //点赞者id
@property (nonatomic,copy) NSString *nick_name;  //昵称
@property (nonatomic,copy) NSString *sex;        //性别
@end


/**
 分享Model
 */
@interface TweetShareModel : NSObject
@property (nonatomic,copy) NSString *content;  //分享内容
@property (nonatomic,copy) NSString *images;   //分享图片
@property (nonatomic,copy) NSString *title;    //分享标题
@property (nonatomic,copy) NSString *url;      //分享链接
@end

/**
 动态Model
 */
@interface MLTweetModel : NSObject
@property (nonatomic,copy) NSString *news_id;       //新闻id
@property (nonatomic,copy) NSString *news_content;  //动态内容
@property (nonatomic,copy) NSString *comments;      //评论数
@property (nonatomic,copy) NSString *community_id;  //小区id
@property (nonatomic,copy) NSString *community_name;//小区名称
@property (nonatomic,copy) NSString *is_like;       //本人是否点赞过
@property (nonatomic,copy) NSString *is_me;         //是否是我发布的本条动态
@property (nonatomic,copy) NSString *likes;         //点赞数
@property (nonatomic,copy) NSString *nosee;         //Y不想看到本条；N是能看到本条
@property (nonatomic,copy) NSString *post_location; //发布位置
@property (nonatomic,copy) NSString *post_time;     //发布时间
@property (nonatomic,copy) NSString *member_id;     //用户id
@property (nonatomic,copy) NSString *avatar;        //头像
@property (nonatomic,copy) NSString *nick_name;     //昵称
@property (nonatomic,copy) NSString *sex;           //性别
@property (nonatomic,copy) NSString *timeLine;      //时间线(新加的参数用于个人动态)
@property (nonatomic,assign) BOOL isShowTimeLine;   //是否显示时间线(新加的参数用于个人动态)

//图片,视频,点赞,评论数组
@property (nonatomic,strong) NSArray<TweetPictureModel *> *tweetPictureArray;
@property (nonatomic,strong) NSArray<TweetVideoModel*> *tweetVideoArray;
@property (nonatomic,strong) NSArray<TweetVoiceModel*> *tweetVoiceArray;
@property (nonatomic,strong) NSMutableArray<TweetCommentModel *> *commentArray;
@property (nonatomic,strong) NSMutableArray<TweetLikeModel *> *likesArray;
@property (nonatomic,copy)   TweetShareModel *share;
@end

