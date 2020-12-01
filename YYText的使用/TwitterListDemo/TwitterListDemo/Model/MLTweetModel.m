//
//  MLTweetModel.m
//  MeiLin
//
//  Created by 曹学亮 on 16/10/8.
//  Copyright © 2016年 Li Chuanliang. All rights reserved.
//

#import "MLTweetModel.h"

@implementation TweetPictureModel
@end

@implementation TweetVideoModel
@end

@implementation TweetVoiceModel
@end

@implementation TweetCommentModel
@end

@implementation TweetLikeModel
@end

@implementation MLTweetModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tweetPictureArray" : @"images_json",
             @"commentArray" : @"comment_list",
             @"likesArray" : @"like_list",
             @"tweetVideoArray" : @"video_json",
             @"tweetVoiceArray" : @"voice_json",
           };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tweetPictureArray" : [TweetPictureModel class],
             @"commentArray" : [TweetCommentModel class],
             @"likesArray" : [TweetLikeModel class],
             @"tweetVideoArray" : [TweetVideoModel class],
             @"tweetVoiceArray" : [TweetVoiceModel class],
           };
}

@end

