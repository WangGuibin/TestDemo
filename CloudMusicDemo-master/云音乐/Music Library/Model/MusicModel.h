//
//  MusicModel.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic,strong) NSString *author_name;//歌手
//@property (nonatomic,strong) NSString *pic_big;//歌手图片大
//@property (nonatomic,strong) NSString *si_proxycompany;//出品公司
//@property (nonatomic,strong) NSString *rank;//排名
//@property (nonatomic,strong) NSString *lrclink;//下载歌词
@property (nonatomic,strong) NSString *img;//歌手图片
@property (nonatomic,strong) NSString *lyrics;//歌词
//@property (nonatomic,strong) NSString *timeLength;//时长
@property (nonatomic,strong) NSString *play_url;//mp3
@property (nonatomic,strong) NSString *song_name;//歌曲名称

@end
